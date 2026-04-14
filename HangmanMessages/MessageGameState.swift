import Foundation

enum MessagePhase: String, Codable {
    case wordSet      // Sender set a word, waiting for guesser
    case completed    // Game finished
}

struct MessageGameState: Codable {
    let targetWord: String
    let senderName: String
    let senderIdentifier: String?
    let phase: MessagePhase
    var guessedLetters: [String]
    var wrongWordGuesses: [String]
    var won: Bool

    init(targetWord: String, senderName: String, senderIdentifier: String?) {
        self.targetWord = targetWord
        self.senderName = senderName
        self.senderIdentifier = senderIdentifier
        self.phase = .wordSet
        self.guessedLetters = []
        self.wrongWordGuesses = []
        self.won = false
    }

    init(targetWord: String, senderName: String, senderIdentifier: String?, guessedLetters: Set<Character>, wrongWordGuesses: [String], won: Bool) {
        self.targetWord = targetWord
        self.senderName = senderName
        self.senderIdentifier = senderIdentifier
        self.phase = .completed
        self.guessedLetters = guessedLetters.map(String.init).sorted()
        self.wrongWordGuesses = wrongWordGuesses
        self.won = won
    }

    // MARK: - URL Encoding

    func encodeToURL() -> URL? {
        guard let data = try? JSONEncoder().encode(self) else { return nil }
        let base64 = data.base64EncodedString()
        var components = URLComponents()
        components.scheme = "hangman"
        components.host = "game"
        components.queryItems = [URLQueryItem(name: "state", value: base64)]
        return components.url
    }

    static func decode(from url: URL) -> MessageGameState? {
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: false),
              let base64 = components.queryItems?.first(where: { $0.name == "state" })?.value,
              let data = Data(base64Encoded: base64) else { return nil }
        return try? JSONDecoder().decode(MessageGameState.self, from: data)
    }
}
