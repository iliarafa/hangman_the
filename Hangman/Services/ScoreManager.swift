import SwiftUI

@Observable
final class ScoreManager {
    private(set) var wins: Int
    private(set) var losses: Int
    private(set) var currentStreak: Int
    private(set) var bestStreak: Int

    private let defaults = UserDefaults.standard

    init() {
        wins = UserDefaults.standard.integer(forKey: "hangman_wins")
        losses = UserDefaults.standard.integer(forKey: "hangman_losses")
        currentStreak = UserDefaults.standard.integer(forKey: "hangman_currentStreak")
        bestStreak = UserDefaults.standard.integer(forKey: "hangman_bestStreak")
    }

    var scores: ScoreData {
        ScoreData(
            wins: wins,
            losses: losses,
            currentStreak: currentStreak,
            bestStreak: bestStreak
        )
    }

    func recordWin() {
        wins += 1
        currentStreak += 1
        if currentStreak > bestStreak {
            bestStreak = currentStreak
        }
        save()
    }

    func recordLoss() {
        losses += 1
        currentStreak = 0
        save()
    }

    func resetScores() {
        wins = 0
        losses = 0
        currentStreak = 0
        bestStreak = 0
        save()
    }

    private func save() {
        defaults.set(wins, forKey: "hangman_wins")
        defaults.set(losses, forKey: "hangman_losses")
        defaults.set(currentStreak, forKey: "hangman_currentStreak")
        defaults.set(bestStreak, forKey: "hangman_bestStreak")
    }
}
