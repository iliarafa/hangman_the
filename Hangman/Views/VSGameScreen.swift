import SwiftUI

struct VSGameScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            header
            hangmanArea
            wordArea

            if viewModel.gameStatus == .playing {
                keyboardArea
            } else {
                gameResult
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .navigationBarBackButtonHidden(true)
    }

    private var header: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(viewModel.session.guesserName)
                        .font(.system(size: 18, weight: .bold, design: .monospaced))
                    Text("Round \(viewModel.session.round)")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text("\(viewModel.wrongGuessCount)/6")
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
        WordDisplay(
            displayWord: viewModel.displayWord,
            revealWord: viewModel.gameStatus == .lost ? viewModel.targetWord : nil
        )
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
        .disabled(viewModel.gameStatus != .playing)
    }

    private var gameResult: some View {
        VStack(spacing: 16) {
            if viewModel.gameStatus == .won {
                Text(ASCIIArt.trophy)
                    .font(.system(size: 12, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("\(viewModel.session.guesserName) WON")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
            } else {
                Text(ASCIIArt.skull)
                    .font(.system(size: 12, design: .monospaced))
                    .multilineTextAlignment(.center)

                Text("\(viewModel.session.guesserName) LOST")
                    .font(.system(size: 32, weight: .black, design: .monospaced))
                Text("The word was \(viewModel.targetWord)")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
            }

            Button {
                viewModel.endRound()
                onContinue()
            } label: {
                Text("CONTINUE")
                    .asciiBracket(.primary)
            }
        }
        .padding(.vertical, 16)
    }
}
