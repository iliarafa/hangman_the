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
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
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
                Text("YOU WON")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                Text("Streak: \(viewModel.scores.currentStreak)")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
            } else {
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
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundStyle(.background)
                    .padding(.horizontal, 32)
                    .padding(.vertical, 14)
                    .background(.primary, in: RoundedRectangle(cornerRadius: 8))
            }
        }
        .padding(.vertical, 16)
    }
}
