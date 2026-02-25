import Foundation

enum Setter {
    case player1
    case player2
}

struct VSSession {
    var player1Name: String
    var player2Name: String
    var player1Score: Int = 0
    var player2Score: Int = 0
    var round: Int = 1
    var currentSetter: Setter = .player1

    var currentGuesser: Setter {
        currentSetter == .player1 ? .player2 : .player1
    }

    var setterName: String {
        currentSetter == .player1 ? player1Name : player2Name
    }

    var guesserName: String {
        currentGuesser == .player1 ? player1Name : player2Name
    }

    mutating func endRound(guesserWon: Bool) {
        if guesserWon {
            switch currentGuesser {
            case .player1: player1Score += 1
            case .player2: player2Score += 1
            }
        } else {
            switch currentSetter {
            case .player1: player1Score += 1
            case .player2: player2Score += 1
            }
        }
        currentSetter = currentSetter == .player1 ? .player2 : .player1
        round += 1
    }

    var winnerName: String? {
        if player1Score > player2Score { return player1Name }
        if player2Score > player1Score { return player2Name }
        return nil
    }
}
