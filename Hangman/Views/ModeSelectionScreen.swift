import SwiftUI

struct ModeSelectionScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @Environment(\.dismiss) private var dismiss
    @State private var showVSMode = false

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Button {
                    UIView.setAnimationsEnabled(false)
                    dismiss()
                    DispatchQueue.main.async {
                        UIView.setAnimationsEnabled(true)
                    }
                } label: {
                    Text("< BACK")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                Spacer()
            }

            Spacer()

            ASCIITitleBox("SELECT MODE", charWidth: 22)

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
            Spacer()
        }
        .padding()
        .navigationBarHidden(true)
    }
}
