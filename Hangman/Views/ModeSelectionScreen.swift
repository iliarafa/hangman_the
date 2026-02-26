import SwiftUI

struct ModeSelectionScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @Environment(\.dismiss) private var dismiss
    @State private var showVSMode = false
    @State private var showArcade = false
    @State private var isFlooding = false

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
                guard !isFlooding else { return }
                isFlooding = true
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
        .overlay {
            if isFlooding {
                PixelFloodView(phase: .flooding) {
                    UIView.setAnimationsEnabled(false)
                    showArcade = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                        UIView.setAnimationsEnabled(true)
                    }
                    isFlooding = false
                }
            }
        }
        .navigationDestination(isPresented: $showArcade) {
            GameScreen(
                viewModel: GameViewModel(
                    wordService: wordService,
                    soundManager: soundManager,
                    scoreManager: scoreManager
                ),
                playEntryTransition: true
            )
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToHome)) { _ in
            UIView.setAnimationsEnabled(false)
            showArcade = false
            dismiss()
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(true)
            }
        }
    }
}
