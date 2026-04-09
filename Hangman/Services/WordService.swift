import Foundation

struct WordResult {
    let word: String
    let isOffline: Bool
}

actor WordService {
    private var fallbackWords: [String]
    private var fallbackByDifficulty: [Difficulty: [String]]

    init() {
        let words: [String]
        if let url = Bundle.main.url(forResource: "fallback_words", withExtension: "txt"),
           let content = try? String(contentsOf: url, encoding: .utf8) {
            words = content.components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.count >= 4 && $0.count <= 10 }
        } else {
            words = []
        }
        self.fallbackWords = words
        self.fallbackByDifficulty = Dictionary(grouping: words, by: { Difficulty.score(for: $0) })
    }

    func fetchWord() async -> String {
        let result = await fetchWordResult()
        return result.word
    }

    /// Fetches a word matching the requested difficulty. Retries the network
    /// up to `maxAttempts` times to find a matching word, then falls back to
    /// the bundled list filtered by score.
    func fetchWord(matching difficulty: Difficulty) async -> WordResult {
        let maxAttempts = 5
        for _ in 0..<maxAttempts {
            let result = await fetchWordResult()
            if Difficulty.score(for: result.word) == difficulty {
                return result
            }
            // If the network is offline, the result already came from fallback —
            // no point retrying the network. Break to the difficulty-aware fallback.
            if result.isOffline { break }
        }
        return WordResult(
            word: randomFallbackWord(matching: difficulty, range: wordLengthRange),
            isOffline: true
        )
    }

    private var wordLengthRange: ClosedRange<Int> {
        let pref = UserDefaults.standard.string(forKey: "hangman_wordLength") ?? "any"
        switch pref {
        case "short": return 4...5
        case "medium": return 6...7
        case "long": return 8...10
        default: return 4...10
        }
    }

    func fetchWordResult() async -> WordResult {
        let range = wordLengthRange
        let wordLength = Int.random(in: range)
        let urlString = "https://random-word-api.vercel.app/api?words=1&length=\(wordLength)"

        guard let url = URL(string: urlString) else {
            return WordResult(word: randomFallbackWord(range: range), isOffline: true)
        }

        do {
            var request = URLRequest(url: url)
            request.timeoutInterval = 5
            let (data, response) = try await URLSession.shared.data(for: request)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let words = try? JSONDecoder().decode([String].self, from: data),
                  let word = words.first,
                  !word.isEmpty,
                  word.allSatisfy({ $0.isLetter }) else {
                return WordResult(word: randomFallbackWord(range: range), isOffline: true)
            }
            return WordResult(word: word.uppercased(), isOffline: false)
        } catch {
            return WordResult(word: randomFallbackWord(range: range), isOffline: true)
        }
    }

    private func randomFallbackWord(range: ClosedRange<Int> = 4...10) -> String {
        let source = fallbackWords.isEmpty ? defaultWords : fallbackWords
        let filtered = source.filter { range.contains($0.count) }
        let words = filtered.isEmpty ? source : filtered
        return (words.randomElement() ?? "SWIFT").uppercased()
    }

    private func randomFallbackWord(matching difficulty: Difficulty, range: ClosedRange<Int>) -> String {
        let bucket: [String]
        if let bundled = fallbackByDifficulty[difficulty], !bundled.isEmpty {
            bucket = bundled
        } else {
            bucket = defaultWords.filter { Difficulty.score(for: $0) == difficulty }
        }
        let filtered = bucket.filter { range.contains($0.count) }
        let pool = filtered.isEmpty ? bucket : filtered
        return (pool.randomElement() ?? randomFallbackWord(range: range)).uppercased()
    }

    private let defaultWords = [
        // 4-letter
        "arch", "barn", "calm", "dock", "fawn",
        "glow", "haze", "jump", "knot", "lamp", "mist", "pond",
        // 5-letter
        "apple", "brave", "dance", "ember", "frost",
        "grape", "ivory", "kneel", "lunar", "maple", "ocean", "pearl",
        // 6-letter
        "anchor", "basket", "candle", "dragon", "falcon",
        "garden", "harbor", "island", "jungle", "legend", "magnet", "mirror",
        // 7-letter
        "balance", "cabinet", "diamond", "eclipse", "fashion",
        "crystal", "blanket", "chimney", "coastal", "comfort", "dolphin", "express",
        // 8-letter
        "absolute", "birthday", "calendar", "campfire", "champion",
        "cinnamon", "climbing", "compound", "criminal", "cultural", "database", "airplane",
        // 9-letter
        "adventure", "beautiful", "butterfly", "calculate", "character",
        "chocolate", "classroom", "companion", "confident", "crocodile", "dangerous", "dedicated",
        // 10-letter
        "accelerate", "atmosphere", "basketball", "birthplace", "camouflage",
        "cheesecake", "checkpoint", "combustion", "connection", "decoration", "earthquake", "experiment"
    ]
}
