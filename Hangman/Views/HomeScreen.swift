import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @State private var showVSMode = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            titleSection
            Spacer()
            playButton
            vsButton
            quickStats
            Spacer()
            navLinks
        }
        .padding()
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            Text("HANGMAN")
                .font(.system(size: 48, weight: .black, design: .monospaced))
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
            Text("PLAY")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(.primary, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 20)
    }

    private var vsButton: some View {
        Button {
            showVSMode = true
        } label: {
            Text("VS MODE")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(.primary, lineWidth: 2)
                )
        }
        .padding(.horizontal, 20)
        .fullScreenCover(isPresented: $showVSMode) {
            VSModeView(soundManager: soundManager)
        }
    }

    private var quickStats: some View {
        let scores = scoreManager.scores
        return HStack(spacing: 24) {
            statBadge(value: "\(scores.wins)", label: "Wins")
            statBadge(value: "\(scores.currentStreak)", label: "Streak")
            statBadge(value: "\(scores.totalGames)", label: "Played")
        }
    }

    private func statBadge(value: String, label: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.system(size: 28, weight: .bold, design: .monospaced))
            Text(label)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(.secondary)
        }
        .frame(width: 70)
    }

    private var navLinks: some View {
        NavigationLink {
            StatsScreen(scoreManager: scoreManager)
        } label: {
            Text("Statistics")
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.secondary)
                .underline()
        }
        .padding(.bottom, 8)
    }
}
