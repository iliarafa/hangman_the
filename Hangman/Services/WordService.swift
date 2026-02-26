import Foundation

actor WordService {
    private var fallbackWords: [String]

    init() {
        if let url = Bundle.main.url(forResource: "fallback_words", withExtension: "txt"),
           let content = try? String(contentsOf: url, encoding: .utf8) {
            self.fallbackWords = content.components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.count >= 4 && $0.count <= 10 }
        } else {
            self.fallbackWords = []
        }
    }

    func fetchWord() async -> String {
        let wordLength = Int.random(in: 4...10)
        let urlString = "https://random-word-api.vercel.app/api?words=1&length=\(wordLength)"

        guard let url = URL(string: urlString) else {
            return randomFallbackWord()
        }

        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200,
                  let words = try? JSONDecoder().decode([String].self, from: data),
                  let word = words.first,
                  !word.isEmpty,
                  word.allSatisfy({ $0.isLetter }) else {
                return randomFallbackWord()
            }
            return word.uppercased()
        } catch {
            return randomFallbackWord()
        }
    }

    private func randomFallbackWord() -> String {
        let words = fallbackWords.isEmpty ? defaultWords : fallbackWords
        return (words.randomElement() ?? "SWIFT").uppercased()
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
