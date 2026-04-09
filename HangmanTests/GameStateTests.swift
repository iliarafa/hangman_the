import Testing
@testable import Hangman

struct GameStateTests {

    // MARK: - Initial State

    @Test func initialState() {
        let game = GameState()
        #expect(game.targetWord == "")
        #expect(game.guessedLetters.isEmpty)
        #expect(game.wrongWordGuesses.isEmpty)
        #expect(game.status == .playing)
        #expect(game.wrongGuessCount == 0)
    }

    // MARK: - Display Word

    @Test func displayWordShowsGuessedLetters() {
        var game = GameState()
        game.targetWord = "HELLO"
        game.guessedLetters = ["H", "L"]
        let display = game.displayWord
        #expect(display == [Character("H"), nil, Character("L"), Character("L"), nil])
    }

    @Test func displayWordAllGuessed() {
        var game = GameState()
        game.targetWord = "HI"
        game.guessedLetters = ["H", "I"]
        #expect(game.displayWord == [Character("H"), Character("I")])
    }

    // MARK: - Wrong Guesses

    @Test func wrongGuessesTrackedCorrectly() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["C", "X", "Z"]
        #expect(game.wrongGuesses.sorted() == ["X", "Z"])
        #expect(game.wrongGuessCount == 2)
    }

    @Test func wrongWordGuessesCountTowardTotal() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["X"]
        _ = game.guessWord("DOG")
        #expect(game.wrongGuessCount == 2) // 1 letter + 1 word
    }

    // MARK: - Win Condition

    @Test func isWonWhenAllLettersGuessed() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["C", "A", "T"]
        #expect(game.isWon)
    }

    @Test func isNotWonWhenIncomplete() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["C", "A"]
        #expect(!game.isWon)
    }

    @Test func isNotWonWhenTargetEmpty() {
        let game = GameState()
        #expect(!game.isWon)
    }

    // MARK: - Loss Condition

    @Test func isLostAfterSixWrongGuesses() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["X", "Y", "Z", "W", "V", "U"]
        #expect(game.isLost)
        #expect(game.wrongGuessCount == 6)
    }

    @Test func isNotLostWithFiveWrongGuesses() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["X", "Y", "Z", "W", "V"]
        #expect(!game.isLost)
    }

    // MARK: - Word Guessing

    @Test func correctWordGuessRevealsAllLetters() {
        var game = GameState()
        game.targetWord = "cat"
        let result = game.guessWord("CAT")
        #expect(result == true)
        #expect(game.isWon)
    }

    @Test func incorrectWordGuessAddsToWrongList() {
        var game = GameState()
        game.targetWord = "CAT"
        let result = game.guessWord("DOG")
        #expect(result == false)
        #expect(game.wrongWordGuesses == ["DOG"])
    }

    @Test func duplicateWrongWordGuessNotCounted() {
        var game = GameState()
        game.targetWord = "CAT"
        _ = game.guessWord("DOG")
        _ = game.guessWord("DOG")
        #expect(game.wrongWordGuesses.count == 1)
        #expect(game.wrongGuessCount == 1)
    }

    @Test func wordGuessIgnoredWhenNotPlaying() {
        var game = GameState()
        game.targetWord = "CAT"
        game.status = .won
        let result = game.guessWord("CAT")
        #expect(result == false)
    }

    @Test func emptyWordGuessIgnored() {
        var game = GameState()
        game.targetWord = "CAT"
        let result = game.guessWord("  ")
        #expect(result == false)
        #expect(game.wrongWordGuesses.isEmpty)
    }

    // MARK: - Correct Guesses

    @Test func correctGuessesFiltersToMatchingLetters() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["C", "X", "A"]
        #expect(game.correctGuesses == ["C", "A"])
    }

    // MARK: - Case Insensitivity

    @Test func wordGuessIsCaseInsensitive() {
        var game = GameState()
        game.targetWord = "Hello"
        let result = game.guessWord("hello")
        #expect(result == true)
        #expect(game.isWon)
    }

    // MARK: - Hints

    @Test func hintRevealsOneLetter() {
        var game = GameState()
        game.targetWord = "CAT"
        let before = game.correctGuesses.count
        let letter = game.useHint()
        #expect(letter != nil)
        #expect(game.correctGuesses.count == before + 1)
    }

    @Test func hintNotAvailableWithOnlyOneLetterLeft() {
        var game = GameState()
        game.targetWord = "CAT"
        game.guessedLetters = ["C", "A"] // only T left
        #expect(game.hintsRemaining == 0)
        #expect(game.useHint() == nil)
    }

    @Test func hintNotAvailableWhenNotPlaying() {
        var game = GameState()
        game.targetWord = "CAT"
        game.status = .won
        #expect(game.useHint() == nil)
    }

    @Test func hintsRemainingCountsCorrectly() {
        var game = GameState()
        game.targetWord = "CAT" // 3 unique letters
        #expect(game.hintsRemaining == 2) // can hint 2, must guess last one
        _ = game.useHint()
        #expect(game.hintsRemaining == 1)
    }

    // MARK: - Fixed mistake budget

    @Test func maxWrongGuessesIsAlwaysSix() {
        let game = GameState(targetWord: "CAT")
        #expect(game.maxWrongGuesses == 6)
        #expect(GameState.maxWrongGuesses == 6)
    }

    // MARK: - Difficulty scoring

    @Test func easyWordsScoreAsEasy() {
        // Common letters, repeats, healthy vowel ratio.
        #expect(Difficulty.score(for: "banana") == .easy)
        #expect(Difficulty.score(for: "apple") == .easy)
    }

    @Test func shortTrickyWordsScoreAsHard() {
        // 4 letters or fewer + rare letter + low vowel ratio = hard.
        #expect(Difficulty.score(for: "lynx") == .hard)
        #expect(Difficulty.score(for: "jazz") == .hard)
    }

    @Test func longUnusualWordsScoreAsHard() {
        // No standard vowels at all + all unique letters = hard.
        #expect(Difficulty.score(for: "rhythm") == .hard)
    }

    @Test func midLengthCommonWordsScoreAsNormal() {
        #expect(Difficulty.score(for: "garden") == .normal)
    }

    @Test func scoringIsCaseInsensitive() {
        #expect(Difficulty.score(for: "LYNX") == Difficulty.score(for: "lynx"))
    }

    @Test func emptyWordIsTreatedAsNormal() {
        #expect(Difficulty.score(for: "") == .normal)
    }
}
