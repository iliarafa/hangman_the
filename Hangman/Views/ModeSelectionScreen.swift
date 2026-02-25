import SwiftUI

struct ModeSelectionScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @State private var showVSMode = false

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text("SELECT MODE")
                .font(.system(size: 32, weight: .black, design: .monospaced))

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
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(.primary, in: RoundedRectangle(cornerRadius: 8))
            }
            .padding(.horizontal, 20)

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

            Spacer()
        }
        .padding()
    }
}
