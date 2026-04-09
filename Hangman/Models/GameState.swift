import Foundation

enum LetterState {
    case unused
    case correct
    case wrong
}

enum GameStatus: Equatable {
    case playing
    case won
    case lost
}

enum Difficulty: String, CaseIterable {
    case easy
    case normal
    case hard

    var displayName: String { rawValue.uppercased() }

    /// Heuristic difficulty score for a candidate word.
    /// Considers length, rare letters, vowel ratio, and letter uniqueness.
    static func score(for word: String) -> Difficulty {
        let upper = word.uppercased()
        let letters = Array(upper)
        guard !letters.isEmpty else { return .normal }

        var points = 0

        // Length: short words give the player less context; very long words
        // are slightly harder than mid-length but usually constrain guesses well.
        let length = letters.count
        if length <= 4 { points += 2 }
        else if length >= 9 { points += 1 }

        // Rare letters disproportionately raise difficulty.
        let rare: Set<Character> = ["J", "Q", "X", "Z", "K", "V", "W", "Y"]
        let rareCount = letters.filter { rare.contains($0) }.count
        points += rareCount * 2

        // Words with all unique letters give nothing back on a correct guess
        // beyond the single position — harder than words with repeats.
        if Set(letters).count == letters.count { points += 1 }

        // Low vowel ratio means the player can't quickly anchor with A/E/I/O/U.
        let vowels: Set<Character> = ["A", "E", "I", "O", "U"]
        let vowelRatio = Double(letters.filter { vowels.contains($0) }.count) / Double(length)
        if vowelRatio < 0.25 { points += 2 }
        else if vowelRatio < 0.35 { points += 1 }

        switch points {
        case ...1: return .easy
        case 2...3: return .normal
        default: return .hard
        }
    }
}

struct GameState {
    static let maxWrongGuesses = 6

    var targetWord: String = ""
    var guessedLetters: Set<Character> = []
    var wrongWordGuesses: [String] = []
    var status: GameStatus = .playing

    var maxWrongGuesses: Int { Self.maxWrongGuesses }

    init(targetWord: String = "") {
        self.targetWord = targetWord
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

    var hintsRemaining: Int {
        let unrevealed = Set(targetWord.uppercased()).subtracting(guessedLetters)
        // Can't hint if it would reveal the last letter (that's winning, not hinting)
        return max(0, unrevealed.count - 1)
    }

    mutating func useHint() -> Character? {
        let unrevealed = Array(Set(targetWord.uppercased()).subtracting(guessedLetters))
        // Need at least 2 unrevealed letters (hint one, leave one to guess)
        guard unrevealed.count > 1, status == .playing else { return nil }
        let letter = unrevealed.randomElement()!
        guessedLetters.insert(letter)
        return letter
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
