import SwiftUI

struct StatsScreen: View {
    let scoreManager: ScoreManager

    var body: some View {
        let scores = scoreManager.scores

        ZStack {
            LinearGradient(
                colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    Text("Statistics")
                        .font(.system(size: 34, weight: .black, design: .rounded))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.blue, .purple],
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .padding(.top, 8)

                    // Win rate ring
                    winRateRing(scores: scores)

                    // Stats grid
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                        statCard(title: "Wins", value: "\(scores.wins)", icon: "trophy.fill", color: .green)
                        statCard(title: "Losses", value: "\(scores.losses)", icon: "xmark.circle.fill", color: .red)
                        statCard(title: "Current Streak", value: "\(scores.currentStreak)", icon: "flame.fill", color: .orange)
                        statCard(title: "Best Streak", value: "\(scores.bestStreak)", icon: "star.fill", color: .yellow)
                    }
                    .padding(.horizontal)

                    Spacer(minLength: 40)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }

    @ViewBuilder
    private func winRateRing(scores: ScoreData) -> some View {
        let rate = scores.winRate

        ZStack {
            Circle()
                .stroke(Color.gray.opacity(0.2), lineWidth: 12)

            Circle()
                .trim(from: 0, to: rate)
                .stroke(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    style: StrokeStyle(lineWidth: 12, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut(duration: 1), value: rate)

            VStack(spacing: 2) {
                Text("\(Int(rate * 100))%")
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                Text("Win Rate")
                    .font(.system(.caption, design: .rounded))
                    .foregroundStyle(.secondary)
            }
        }
        .frame(width: 140, height: 140)
        .padding(.vertical, 8)
    }

    private func statCard(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(color)

            Text(value)
                .font(.system(size: 32, weight: .bold, design: .rounded))

            Text(title)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 20)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }
}
