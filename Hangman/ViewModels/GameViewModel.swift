import SwiftUI

@Observable
final class GameViewModel {
    private(set) var game = GameState()
    private(set) var isLoading = false

    private let wordService: WordService
    private let soundManager: SoundManager
    private let scoreManager: ScoreManager

    init(wordService: WordService, soundManager: SoundManager, scoreManager: ScoreManager) {
        self.wordService = wordService
        self.soundManager = soundManager
        self.scoreManager = scoreManager
    }

    var targetWord: String { game.targetWord }
    var guessedLetters: Set<Character> { game.guessedLetters }
    var wrongGuesses: [Character] { game.wrongGuesses }
    var wrongGuessCount: Int { game.wrongGuessCount }
    var displayWord: [Character?] { game.displayWord }
    var gameStatus: GameStatus { game.status }
    var scores: ScoreData { scoreManager.scores }

    func startNewGame() async {
        isLoading = true
        let word = await wordService.fetchWord()
        game = GameState(targetWord: word)
        isLoading = false
    }

    func guess(letter: Character) {
        guard game.status == .playing else { return }
        guard !game.guessedLetters.contains(letter) else { return }

        game.guessedLetters.insert(letter)

        if game.targetWord.uppercased().contains(letter) {
            soundManager.play(.correct)
            if game.isWon {
                game.status = .won
                scoreManager.recordWin()
                soundManager.play(.win)
            }
        } else {
            soundManager.play(.wrong)
            if game.isLost {
                game.status = .lost
                scoreManager.recordLoss()
                soundManager.play(.lose)
            }
        }
    }

    func letterState(_ letter: Character) -> LetterState {
        guard game.guessedLetters.contains(letter) else { return .unused }
        return game.targetWord.uppercased().contains(letter) ? .correct : .wrong
    }
}

enum LetterState {
    case unused
    case correct
    case wrong
}
