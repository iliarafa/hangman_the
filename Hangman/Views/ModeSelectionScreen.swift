import SwiftUI

struct ModeSelectionScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @State private var showVSMode = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ASCIITitleBox("SELECT MODE", charWidth: 22)

            Spacer()

            NavigationLink {
                GameScreen(
                    viewModel: GameViewModel(
                        wordService: wordService,
                        soundManager: soundManager,
                        scoreManager: scoreManager
                    )
                )
            } label: {
                Text("ARCADE")
                    .asciiBracket(.primary, fontSize: 24)
            }

            Button {
                showVSMode = true
            } label: {
                Text("VS MODE")
                    .asciiBracket(.secondary, fontSize: 24)
            }
            .fullScreenCover(isPresented: $showVSMode) {
                VSModeView(soundManager: soundManager)
            }

            Spacer()
        }
        .padding()
    }
}
