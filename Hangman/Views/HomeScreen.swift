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
        ASCIITitleBox("HANGMAN (THE)", charWidth: 26)
    }

    private var playButton: some View {
        NavigationLink {
            ModeSelectionScreen(
                scoreManager: scoreManager,
                wordService: wordService,
                soundManager: soundManager
            )
        } label: {
            Text("PLAY")
                .asciiBracket(.primary, fontSize: 24)
        }
    }

    private var navLinks: some View {
        NavigationLink {
            StatsScreen(scoreManager: scoreManager)
        } label: {
            Text("Statistics")
                .asciiBracket(.secondary, fontSize: 16)
        }
        .padding(.bottom, 8)
    }
}
