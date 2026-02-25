import Foundation

actor WordService {
    private var fallbackWords: [String]

    init() {
        if let url = Bundle.main.url(forResource: "fallback_words", withExtension: "txt"),
           let content = try? String(contentsOf: url, encoding: .utf8) {
            self.fallbackWords = content.components(separatedBy: .newlines)
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty && $0.count >= 4 && $0.count <= 8 }
        } else {
            self.fallbackWords = []
        }
    }

    func fetchWord() async -> String {
        let wordLength = Int.random(in: 4...8)
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
        "apple", "brave", "chair", "dance", "eagle",
        "flame", "grape", "house", "ivory", "jolly",
        "knife", "lemon", "mango", "noble", "ocean",
        "piano", "queen", "river", "storm", "tiger",
        "ultra", "vivid", "whale", "youth", "zebra",
        "beach", "cloud", "dream", "frost", "globe",
        "heart", "image", "jewel", "kneel", "light",
        "music", "night", "olive", "pearl", "quiet",
        "robin", "solar", "trail", "unity", "valor",
        "witch", "xerox", "yacht", "zones", "amber",
        "blaze", "coral", "drift", "ember", "fable",
        "grain", "haven", "inlet", "judge", "kayak",
        "lunar", "maple", "nerve", "orbit", "panda",
        "quest", "relay", "shine", "torch", "umbra",
        "vapor", "wound", "pixel", "yeast", "zilch",
        "brush", "candy", "ditch", "elbow", "fairy",
        "ghost", "honor", "irony", "joker", "knack",
        "latch", "merit", "nudge", "oasis", "plumb",
        "quilt", "ridge", "skull", "thumb", "usher",
        "voice", "wrist", "oxide", "young", "zonal"
    ]
}
