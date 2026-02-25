import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @State private var animateTitle = false
    @State private var animateButton = false

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 32) {
                Spacer()
                titleSection
                Spacer()
                playButton
                quickStats
                Spacer()
                navLinks
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 0.8)) {
                animateTitle = true
            }
            withAnimation(.easeOut(duration: 0.6).delay(0.3)) {
                animateButton = true
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [
                Color.blue.opacity(0.15),
                Color.purple.opacity(0.1),
                Color.pink.opacity(0.08)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("HANGMAN")
                .font(.system(size: 48, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.blue, .purple, .pink],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .scaleEffect(animateTitle ? 1 : 0.5)
                .opacity(animateTitle ? 1 : 0)

            Text("Guess the word before it's too late!")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(.secondary)
                .opacity(animateTitle ? 1 : 0)
        }
    }

    private var playButton: some View {
        NavigationLink {
            GameScreen(
                viewModel: GameViewModel(
                    wordService: wordService,
                    soundManager: soundManager,
                    scoreManager: scoreManager
                )
            )
        } label: {
            HStack(spacing: 12) {
                Image(systemName: "play.fill")
                    .font(.title2)
                Text("Play")
                    .font(.system(size: 24, weight: .bold, design: .rounded))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 18)
            .background(
                LinearGradient(
                    colors: [.blue, .purple],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                in: RoundedRectangle(cornerRadius: 20)
            )
            .shadow(color: .purple.opacity(0.4), radius: 12, y: 6)
        }
        .scaleEffect(animateButton ? 1 : 0.8)
        .opacity(animateButton ? 1 : 0)
        .padding(.horizontal, 20)
    }

    private var quickStats: some View {
        let scores = scoreManager.scores
        return HStack(spacing: 24) {
            statBadge(value: "\(scores.wins)", label: "Wins", color: .green)
            statBadge(value: "\(scores.currentStreak)", label: "Streak", color: .orange)
            statBadge(value: "\(scores.totalGames)", label: "Played", color: .blue)
        }
        .opacity(animateButton ? 1 : 0)
    }

    private func statBadge(value: String, label: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(color)
            Text(label)
                .font(.system(.caption, design: .rounded))
                .foregroundStyle(.secondary)
        }
        .frame(width: 70)
    }

    private var navLinks: some View {
        NavigationLink {
            StatsScreen(scoreManager: scoreManager)
        } label: {
            Label("Statistics", systemImage: "chart.bar.fill")
                .font(.system(.body, design: .rounded, weight: .medium))
                .foregroundStyle(.secondary)
        }
        .padding(.bottom, 8)
    }
}
