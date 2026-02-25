import SwiftUI

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
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        guard trimmed.count >= 2, trimmed.count <= 20 else { return false }
        return trimmed.allSatisfy { $0.isLetter }
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

    func endRound() {
        session.endRound(guesserWon: game.status == .won)
    }

    func letterState(_ letter: Character) -> LetterState {
        guard game.guessedLetters.contains(letter) else { return .unused }
        return game.targetWord.uppercased().contains(letter) ? .correct : .wrong
    }
}
