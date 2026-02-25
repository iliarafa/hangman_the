import SwiftUI

struct GameScreen: View {
    @Bindable var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {
            header
            hangmanArea
            wordArea

            if viewModel.gameStatus == .playing || viewModel.isLoading {
                keyboardArea
            } else {
                gameResult
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.startNewGame()
        }
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                Button(action: { dismiss() }) {
                    Text("<<")
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                        .foregroundStyle(.primary)
                }

                Spacer()

                Text("\(viewModel.wrongGuessCount)/6")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))

                Spacer()

                Text("\(viewModel.scores.currentStreak)")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
            }

            ASCIIDivider()
        }
        .padding(.top, 8)
    }

    private var hangmanArea: some View {
        ASCIIHangman(wrongGuessCount: viewModel.wrongGuessCount)
            .frame(maxHeight: 220)
            .padding(.vertical, 8)
    }

    private var wordArea: some View {
        Group {
            if viewModel.isLoading {
                ProgressView()
                    .frame(height: 44)
            } else {
                WordDisplay(
                    displayWord: viewModel.displayWord,
                    revealWord: viewModel.gameStatus == .lost ? viewModel.targetWord : nil
                )
            }
        }
        .padding(.vertical, 8)
    }

    private var keyboardArea: some View {
        VStack(spacing: 12) {
            KeyboardView(
                letterState: { viewModel.letterState($0) },
                onTap: { viewModel.guess(letter: $0) }
            )

            SolveWordView(
                wordLength: viewModel.targetWord.count,
                onSubmit: { viewModel.guessWord($0) }
            )
        }
        .disabled(viewModel.gameStatus != .playing || viewModel.isLoading)
    }

    private var gameResult: some View {
        VStack(spacing: 16) {
            if viewModel.gameStatus == .won {
                Text(ASCIIArt.trophy)
                    .font(.system(size: 12, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("YOU WON")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                Text("Streak: \(viewModel.scores.currentStreak)")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
            } else {
                Text(ASCIIArt.skull)
                    .font(.system(size: 12, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("GAME OVER")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                Text("The word was \(viewModel.targetWord)")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Button(action: {
                Task {
                    await viewModel.startNewGame()
                }
            }) {
                Text("PLAY AGAIN")
                    .asciiBracket(.primary)
            }
        }
        .padding(.vertical, 16)
    }
}
