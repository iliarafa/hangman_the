import SwiftUI

@MainActor
@Observable
final class VSGameViewModel {
    private(set) var session: VSSession
    private(set) var game = GameState()
    private let soundManager: SoundManager

    init(player1: String, player2: String, soundManager: SoundManager) {
        self.session = VSSession(player1Name: player1, player2Name: player2)
        self.soundManager = soundManager
    }

    // MARK: - Game state accessors

    var targetWord: String { game.targetWord }
    var displayWord: [Character?] { game.displayWord }
    var wrongGuessCount: Int { game.wrongGuessCount }
    var gameStatus: GameStatus { game.status }

    // MARK: - Word validation

    func validateWord(_ word: String) -> Bool {
        wordValidationError(word) == nil
    }

    func wordValidationError(_ word: String) -> String? {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Please enter a word" }
        if trimmed.count < 2 { return "Word must be at least 2 characters" }
        if trimmed.count > 12 { return "Word must be 12 characters or less" }
        if !trimmed.allSatisfy({ $0.isLetter }) { return "Letters only" }
        if !WordValidator.isRealWord(trimmed) { return "Not a recognized word" }
        return nil
    }

    // MARK: - Round lifecycle

    func startRound(word: String) {
        game = GameState(targetWord: word.uppercased())
    }

    func guess(letter: Character) {
        guard game.status == .playing else { return }
        guard !game.guessedLetters.contains(letter) else { return }

        game.guessedLetters.insert(letter)

        if game.targetWord.uppercased().contains(letter) {
            soundManager.play(.correct)
            if game.isWon {
                game.status = .won
                soundManager.play(.win)
            }
        } else {
            soundManager.play(.wrong)
            if game.isLost {
                game.status = .lost
                soundManager.play(.lose)
            }
        }
    }

    func guessWord(_ word: String) {
        guard game.status == .playing else { return }
        let previousCount = game.wrongGuessCount
        let isCorrect = game.guessWord(word)
        if isCorrect {
            game.status = .won
            soundManager.play(.win)
        } else if game.wrongGuessCount > previousCount {
            soundManager.play(.wrong)
            if game.isLost {
                game.status = .lost
                soundManager.play(.lose)
            }
        }
    }

    func endRound() {
        session.endRound(guesserWon: game.status == .won)
    }

    func letterState(_ letter: Character) -> LetterState {
        guard game.guessedLetters.contains(letter) else { return .unused }
        return game.targetWord.uppercased().contains(letter) ? .correct : .wrong
    }
}
