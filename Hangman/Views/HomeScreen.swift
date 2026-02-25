import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            titleSection
            Spacer()
            playButton
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
            ModeSelectionScreen(
                scoreManager: scoreManager,
                wordService: wordService,
                soundManager: soundManager
            )
        } label: {
            Image("PlayButton")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
        }
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
