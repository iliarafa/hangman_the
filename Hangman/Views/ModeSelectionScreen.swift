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
                    withoutNavAnimation { dismiss() }
                } label: {
                    Text("< BACK")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                Spacer()
            }

            Spacer()

            ASCIITitleBox("SELECT MODE")

            Button {
                guard !isFlooding else { return }
                isFlooding = true
            } label: {
                Text("ARCADE")
                    .asciiBracket(.primary, fontSize: 24)
            }

            Button {
                withoutNavAnimation { showVSMode = true }
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
                    withoutNavAnimation(restoreDelay: 0.05) {
                        showArcade = true
                        isFlooding = false
                    }
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
            withoutNavAnimation(restoreDelay: 0.1) {
                showArcade = false
                showVSMode = false
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                dismiss()
            }
        }
    }
}
