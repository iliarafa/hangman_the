import Foundation
import Testing
@testable import Hangman

@Suite(.serialized)
struct ScoreManagerTests {

    private func makeManager() -> ScoreManager {
        let keys = ["hangman_wins", "hangman_losses", "hangman_currentStreak", "hangman_bestStreak"]
        for key in keys {
            UserDefaults.standard.removeObject(forKey: key)
        }
        return ScoreManager()
    }

    // MARK: - Initial State

    @Test func freshManagerStartsAtZero() {
        let manager = makeManager()
        let scores = manager.scores
        #expect(scores.wins == 0)
        #expect(scores.losses == 0)
        #expect(scores.currentStreak == 0)
        #expect(scores.bestStreak == 0)
    }

    // MARK: - Record Win

    @Test func recordWinIncrementsWinsAndStreak() {
        let manager = makeManager()
        manager.recordWin()
        #expect(manager.scores.wins == 1)
        #expect(manager.scores.currentStreak == 1)
        #expect(manager.scores.bestStreak == 1)
    }

    @Test func consecutiveWinsBuildStreak() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordWin()
        #expect(manager.scores.currentStreak == 3)
        #expect(manager.scores.bestStreak == 3)
    }

    // MARK: - Record Loss

    @Test func recordLossIncrementsLossesAndResetsStreak() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordLoss()
        #expect(manager.scores.losses == 1)
        #expect(manager.scores.currentStreak == 0)
        #expect(manager.scores.bestStreak == 2)
    }

    // MARK: - Best Streak Preserved

    @Test func bestStreakSurvivesLoss() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordWin()
        manager.recordLoss()
        manager.recordWin()
        #expect(manager.scores.bestStreak == 3)
        #expect(manager.scores.currentStreak == 1)
    }

    @Test func bestStreakUpdatesWhenExceeded() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordLoss()
        manager.recordWin()
        manager.recordWin()
        manager.recordWin()
        #expect(manager.scores.bestStreak == 3)
        #expect(manager.scores.currentStreak == 3)
    }

    // MARK: - Reset

    @Test func resetClearsAllScores() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordLoss()
        manager.resetScores()
        let scores = manager.scores
        #expect(scores.wins == 0)
        #expect(scores.losses == 0)
        #expect(scores.currentStreak == 0)
        #expect(scores.bestStreak == 0)
    }

    // MARK: - Win Rate

    @Test func winRateCalculation() {
        let manager = makeManager()
        manager.recordWin()
        manager.recordWin()
        manager.recordLoss()
        let rate = manager.scores.winRate
        #expect(rate > 0.66)
        #expect(rate < 0.67)
    }

    @Test func winRateZeroWithNoGames() {
        let manager = makeManager()
        #expect(manager.scores.winRate == 0)
    }
}
