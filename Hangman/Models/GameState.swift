import Foundation

enum GameStatus: Equatable {
    case playing
    case won
    case lost
}

enum Difficulty: String, CaseIterable {
    case easy
    case normal
    case hard

    var maxWrongGuesses: Int {
        switch self {
        case .easy: return 8
        case .normal: return 6
        case .hard: return 4
        }
    }

    var displayName: String { rawValue.uppercased() }
}

struct GameState {
    var targetWord: String = ""
    var guessedLetters: Set<Character> = []
    var wrongWordGuesses: [String] = []
    var status: GameStatus = .playing
    let maxWrongGuesses: Int

    init(targetWord: String = "", maxWrongGuesses: Int = 6) {
        self.targetWord = targetWord
        self.maxWrongGuesses = maxWrongGuesses
    }

    var wrongGuesses: [Character] {
        guessedLetters.filter { !targetWord.uppercased().contains($0) }.sorted()
    }

    var wrongGuessCount: Int {
        wrongGuesses.count + wrongWordGuesses.count
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

    mutating func guessWord(_ word: String) -> Bool {
        let cleaned = word.uppercased().trimmingCharacters(in: .whitespacesAndNewlines)
        guard !cleaned.isEmpty, status == .playing else { return false }

        if cleaned == targetWord.uppercased() {
            for char in targetWord.uppercased() {
                guessedLetters.insert(char)
            }
            return true
        } else {
            if !wrongWordGuesses.contains(cleaned) {
                wrongWordGuesses.append(cleaned)
            }
            return false
        }
    }
}
