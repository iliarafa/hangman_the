import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @State private var showModeSelection = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            titleSection
            Spacer()
            playButton
            Spacer()
        }
        .padding()
        .navigationDestination(isPresented: $showModeSelection) {
            ModeSelectionScreen(
                scoreManager: scoreManager,
                wordService: wordService,
                soundManager: soundManager
            )
        }
    }

    private var titleSection: some View {
        ASCIITitleBox("HANGMAN (THE)")
    }

    private var playButton: some View {
        Button {
            withoutNavAnimation { showModeSelection = true }
        } label: {
            Text("PLAY")
                .asciiBracket(.primary, fontSize: 24)
        }
    }
}
