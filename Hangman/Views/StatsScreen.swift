import SwiftUI

struct StatsScreen: View {
    let scoreManager: ScoreManager

    var body: some View {
        let scores = scoreManager.scores

        ScrollView {
            VStack(spacing: 24) {
                Text("Statistics")
                    .font(.system(size: 34, weight: .black, design: .monospaced))
                    .padding(.top, 8)

                Text("\(Int(scores.winRate * 100))%")
                    .font(.system(size: 64, weight: .black, design: .monospaced))
                Text("Win Rate")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundStyle(.secondary)

                Divider()
                    .padding(.horizontal)

                VStack(spacing: 0) {
                    statRow(title: "Wins", value: "\(scores.wins)")
                    Divider().padding(.horizontal)
                    statRow(title: "Losses", value: "\(scores.losses)")
                    Divider().padding(.horizontal)
                    statRow(title: "Current Streak", value: "\(scores.currentStreak)")
                    Divider().padding(.horizontal)
                    statRow(title: "Best Streak", value: "\(scores.bestStreak)")
                }

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 16, design: .monospaced))
            Spacer()
            Text(value)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
        }
        .padding(.horizontal)
        .padding(.vertical, 14)
    }
}
