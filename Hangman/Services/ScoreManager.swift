import SwiftUI

@Observable
final class ScoreManager {
    @ObservationIgnored
    @AppStorage("hangman_wins") private var storedWins = 0
    @ObservationIgnored
    @AppStorage("hangman_losses") private var storedLosses = 0
    @ObservationIgnored
    @AppStorage("hangman_currentStreak") private var storedCurrentStreak = 0
    @ObservationIgnored
    @AppStorage("hangman_bestStreak") private var storedBestStreak = 0

    var scores: ScoreData {
        ScoreData(
            wins: storedWins,
            losses: storedLosses,
            currentStreak: storedCurrentStreak,
            bestStreak: storedBestStreak
        )
    }

    func recordWin() {
        storedWins += 1
        storedCurrentStreak += 1
        if storedCurrentStreak > storedBestStreak {
            storedBestStreak = storedCurrentStreak
        }
    }

    func recordLoss() {
        storedLosses += 1
        storedCurrentStreak = 0
    }

    func resetScores() {
        storedWins = 0
        storedLosses = 0
        storedCurrentStreak = 0
        storedBestStreak = 0
    }
}
