import SwiftUI

struct StatsScreen: View {
    let scoreManager: ScoreManager

    @Environment(\.dismiss) private var dismiss
    @State private var showResetConfirmation = false
    @State private var showHistory = false

    var body: some View {
        let scores = scoreManager.scores

        ScrollView {
            VStack(spacing: 24) {
                HStack {
                    Button {
                        withoutNavAnimation { dismiss() }
                    } label: {
                        Text("< BACK")
                            .font(AppTheme.font(size: 18))
                            .secondaryStyle()
                    }
                    .buttonStyle(.plain)
                    Spacer()
                }

                ASCIITitleBox("STATISTICS")
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

                Button {
                    withoutNavAnimation { showHistory = true }
                } label: {
                    Text("DICTIONARY")
                        .asciiBracket(.primary, fontSize: 24)
                }

                ASCIIDivider()
                    .padding(.horizontal)

                Button {
                    showResetConfirmation = true
                } label: {
                    Text("RESET")
                        .asciiBracket(.secondary, fontSize: 16)
                }

                Spacer(minLength: 40)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationDestination(isPresented: $showHistory) {
            HistoryScreen(scoreManager: scoreManager)
        }
        .alert("Reset Statistics?", isPresented: $showResetConfirmation) {
            Button("Reset", role: .destructive) {
                scoreManager.resetScores()
            }
            Button("Cancel", role: .cancel) {}
        } message: {
            Text("This will permanently erase all your stats.")
        }
    }

    private func statRow(title: String, value: String) -> some View {
        Text(asciiStatRow(title: title, value: value))
            .font(AppTheme.font(size: 18))
            .bodyStyle()
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 6)
    }
}
