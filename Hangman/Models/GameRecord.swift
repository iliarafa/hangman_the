import Foundation

struct GameRecord: Codable, Identifiable {
    let id: UUID
    let word: String
    let won: Bool
    let wrongGuessCount: Int
    let date: Date
    let mode: GameMode
    var definition: String?

    enum GameMode: String, Codable {
        case arcade
        case vs
    }

    init(word: String, won: Bool, wrongGuessCount: Int, mode: GameMode, definition: String? = nil) {
        self.id = UUID()
        self.word = word
        self.won = won
        self.wrongGuessCount = wrongGuessCount
        self.date = Date()
        self.mode = mode
        self.definition = definition
    }
}
