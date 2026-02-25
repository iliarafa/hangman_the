import Foundation

enum GameStatus: Equatable {
    case playing
    case won
    case lost
}

struct GameState {
    var targetWord: String = ""
    var guessedLetters: Set<Character> = []
    var status: GameStatus = .playing

    var maxWrongGuesses: Int { 6 }

    var wrongGuesses: [Character] {
        guessedLetters.filter { !targetWord.uppercased().contains($0) }.sorted()
    }

    var wrongGuessCount: Int {
        wrongGuesses.count
    }

    var correctGuesses: Set<Character> {
        guessedLetters.filter { targetWord.uppercased().contains($0) }
    }

    var displayWord: [Character?] {
        targetWord.uppercased().map { char in
            guessedLetters.contains(char) ? char : nil
        }
    }

    var isWon: Bool {
        !targetWord.isEmpty && targetWord.uppercased().allSatisfy { guessedLetters.contains($0) }
    }

    var isLost: Bool {
        wrongGuessCount >= maxWrongGuesses
    }
}
