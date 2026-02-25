import Foundation

struct ScoreData: Equatable {
    var wins: Int = 0
    var losses: Int = 0
    var currentStreak: Int = 0
    var bestStreak: Int = 0

    var totalGames: Int { wins + losses }

    var winRate: Double {
        guard totalGames > 0 else { return 0 }
        return Double(wins) / Double(totalGames)
    }
}
