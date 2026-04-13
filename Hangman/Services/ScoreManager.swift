import SwiftUI

@Observable
final class ScoreManager {
    private(set) var wins: Int
    private(set) var losses: Int
    private(set) var currentStreak: Int
    private(set) var bestStreak: Int
    private(set) var gameHistory: [GameRecord]

    private let defaults = UserDefaults.standard
    private static let historyKey = "hangman_gameHistory"
    private static let maxHistoryCount = 50

    init() {
        wins = max(0, UserDefaults.standard.integer(forKey: "hangman_wins"))
        losses = max(0, UserDefaults.standard.integer(forKey: "hangman_losses"))
        currentStreak = max(0, UserDefaults.standard.integer(forKey: "hangman_currentStreak"))
        bestStreak = max(0, UserDefaults.standard.integer(forKey: "hangman_bestStreak"))
        if let data = UserDefaults.standard.data(forKey: ScoreManager.historyKey),
           let records = try? JSONDecoder().decode([GameRecord].self, from: data) {
            gameHistory = records
        } else {
            gameHistory = []
        }
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

    func recordGame(_ record: GameRecord) {
        gameHistory.insert(record, at: 0)
        if gameHistory.count > Self.maxHistoryCount {
            gameHistory = Array(gameHistory.prefix(Self.maxHistoryCount))
        }
        saveHistory()
    }

    func updateDefinition(for word: String, definition: String) {
        if let index = gameHistory.firstIndex(where: { $0.word == word && $0.definition == nil }) {
            gameHistory[index].definition = definition
            saveHistory()
        }
    }

    func resetScores() {
        wins = 0
        losses = 0
        currentStreak = 0
        bestStreak = 0
        gameHistory = []
        save()
        saveHistory()
    }

    private func save() {
        defaults.set(wins, forKey: "hangman_wins")
        defaults.set(losses, forKey: "hangman_losses")
        defaults.set(currentStreak, forKey: "hangman_currentStreak")
        defaults.set(bestStreak, forKey: "hangman_bestStreak")
    }

    private func saveHistory() {
        if let data = try? JSONEncoder().encode(gameHistory) {
            defaults.set(data, forKey: Self.historyKey)
        }
    }
}
