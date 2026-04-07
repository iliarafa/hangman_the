import Testing
@testable import Hangman

struct VSSessionTests {

    // MARK: - Initial State

    @Test func initialState() {
        let session = VSSession(player1Name: "Alice", player2Name: "Bob")
        #expect(session.round == 1)
        #expect(session.player1Score == 0)
        #expect(session.player2Score == 0)
        #expect(session.currentSetter == .player1)
    }

    // MARK: - Role Assignment

    @Test func guesserIsOppositeOfSetter() {
        let session = VSSession(player1Name: "Alice", player2Name: "Bob")
        #expect(session.currentGuesser == .player2)
        #expect(session.setterName == "Alice")
        #expect(session.guesserName == "Bob")
    }

    // MARK: - Scoring

    @Test func guesserWinGivesPointToGuesser() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        // Player1 sets, Player2 guesses and wins
        session.endRound(guesserWon: true)
        #expect(session.player2Score == 1)
        #expect(session.player1Score == 0)
    }

    @Test func guesserLossGivesPointToSetter() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        // Player1 sets, Player2 guesses and loses
        session.endRound(guesserWon: false)
        #expect(session.player1Score == 1)
        #expect(session.player2Score == 0)
    }

    // MARK: - Setter Rotation

    @Test func setterAlternatesEachRound() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        #expect(session.currentSetter == .player1)
        session.endRound(guesserWon: true)
        #expect(session.currentSetter == .player2)
        session.endRound(guesserWon: true)
        #expect(session.currentSetter == .player1)
    }

    // MARK: - Round Counter

    @Test func roundIncrements() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        #expect(session.round == 1)
        session.endRound(guesserWon: true)
        #expect(session.round == 2)
        session.endRound(guesserWon: false)
        #expect(session.round == 3)
    }

    // MARK: - Winner

    @Test func winnerIsPlayerWithHigherScore() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        session.player1Score = 3
        session.player2Score = 1
        #expect(session.winnerName == "Alice")
    }

    @Test func winnerIsNilOnTie() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")
        session.player1Score = 2
        session.player2Score = 2
        #expect(session.winnerName == nil)
    }

    @Test func winnerIsNilAtStart() {
        let session = VSSession(player1Name: "Alice", player2Name: "Bob")
        #expect(session.winnerName == nil)
    }

    // MARK: - Multi-Round Scenario

    @Test func fullTwoRoundGame() {
        var session = VSSession(player1Name: "Alice", player2Name: "Bob")

        // Round 1: Alice sets, Bob guesses and wins
        session.endRound(guesserWon: true)
        #expect(session.player2Score == 1) // Bob scored
        #expect(session.round == 2)

        // Round 2: Bob sets, Alice guesses and loses
        session.endRound(guesserWon: false)
        #expect(session.player2Score == 2) // Bob scored again (as setter)
        #expect(session.round == 3)

        #expect(session.winnerName == "Bob")
    }
}
