import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    private(set) var game: GameState
    private(set) var isLoading = false
    private(set) var isOffline = false
    let difficulty: Difficulty

    private let wordService: WordService
    let soundManager: SoundManager
    private let scoreManager: ScoreManager

    init(wordService: WordService, soundManager: SoundManager, scoreManager: ScoreManager, difficulty: Difficulty = .normal) {
        self.wordService = wordService
        self.soundManager = soundManager
        self.scoreManager = scoreManager
        self.difficulty = difficulty
        self.game = GameState(maxWrongGuesses: difficulty.maxWrongGuesses)
        Task { [weak self] in
            await self?.startNewGame()
        }
    }

    var targetWord: String { game.targetWord }
    var guessedLetters: Set<Character> { game.guessedLetters }
    var wrongGuesses: [Character] { game.wrongGuesses }
    var wrongGuessCount: Int { game.wrongGuessCount }
    var displayWord: [Character?] { game.displayWord }
    var gameStatus: GameStatus { game.status }
    var scores: ScoreData { scoreManager.scores }
    var hintsRemaining: Int { game.hintsRemaining }

    func startNewGame() async {
        guard !isLoading else { return }
        isLoading = true
        if game.status != .playing {
            soundManager.playBackgroundMusic("gamemusic")
        }
        let result = await wordService.fetchWordResult()
        game = GameState(targetWord: result.word, maxWrongGuesses: difficulty.maxWrongGuesses)
        isOffline = result.isOffline
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
                recordGame(won: true)
                soundManager.playWinMusic()
            }
        } else {
            soundManager.play(.wrong)
            if game.isLost {
                game.status = .lost
                scoreManager.recordLoss()
                recordGame(won: false)
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
            scoreManager.recordWin()
            recordGame(won: true)
            soundManager.playWinMusic()
        } else if game.wrongGuessCount > previousCount {
            soundManager.play(.wrong)
            if game.isLost {
                game.status = .lost
                scoreManager.recordLoss()
                recordGame(won: false)
                soundManager.play(.lose)
            }
        }
    }

    private func recordGame(won: Bool) {
        scoreManager.recordGame(GameRecord(
            word: game.targetWord,
            won: won,
            wrongGuessCount: game.wrongGuessCount,
            mode: .arcade
        ))
    }

    func useHint() {
        guard let _ = game.useHint() else { return }
        soundManager.play(.correct)
        if game.isWon {
            game.status = .won
            scoreManager.recordWin()
            recordGame(won: true)
            soundManager.playWinMusic()
        }
    }

    func letterState(_ letter: Character) -> LetterState {
        guard game.guessedLetters.contains(letter) else { return .unused }
        return game.targetWord.uppercased().contains(letter) ? .correct : .wrong
    }
}