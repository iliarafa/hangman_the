import SwiftUI

struct ModeSelectionScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @Environment(\.dismiss) private var dismiss
    @State private var showVSMode = false
    @State private var showArcade = false

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

            Button {
                UIView.setAnimationsEnabled(false)
                showArcade = true
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(true)
                }
            } label: {
                Text("ARCADE")
                    .asciiBracket(.primary, fontSize: 24)
            }

            Button {
                UIView.setAnimationsEnabled(false)
                showVSMode = true
                DispatchQueue.main.async {
                    UIView.setAnimationsEnabled(true)
                }
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
        .navigationDestination(isPresented: $showArcade) {
            GameScreen(
                viewModel: GameViewModel(
                    wordService: wordService,
                    soundManager: soundManager,
                    scoreManager: scoreManager
                )
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToHome)) { _ in
            UIView.setAnimationsEnabled(false)
            dismiss()
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}
