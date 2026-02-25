import SwiftUI

struct StatsScreen: View {
    let scoreManager: ScoreManager

    var body: some View {
        let scores = scoreManager.scores

        ScrollView {
            VStack(spacing: 24) {
                ASCIITitleBox("STATISTICS", charWidth: 22)
                    .padding(.top, 8)

                Text("\(Int(scores.winRate * 100))%")
                    .font(AppTheme.font(size: 72))
                    .headlineStyle()
                Text("Win Rate")
                    .font(AppTheme.font(size: 16))
                    .secondaryStyle()

                ASCIIDivider()
                    .padding(.horizontal)

                VStack(spacing: 12) {
                    statRow(title: "Wins", value: "\(scores.wins)")
                    statRow(title: "Losses", value: "\(scores.losses)")
                    statRow(title: "Current Streak", value: "\(scores.currentStreak)")
                    statRow(title: "Best Streak", value: "\(scores.bestStreak)")
                }
                .padding(.horizontal)

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    private func statRow(title: String, value: String) -> some View {
        Text(asciiStatRow(title: title, value: value))
            .font(AppTheme.font(size: 18))
            .bodyStyle()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.vertical, 6)
    }
}
