import SwiftUI

struct VSGameScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onContinue: () -> Void
    @Environment(\.dismiss) private var dismiss
    @State private var showPauseMenu = false
    @State private var didContinue = false

    var body: some View {
        VStack(spacing: 16) {
            header

            Spacer()

            hangmanArea
            wordArea

            if viewModel.gameStatus == .playing {
                keyboardArea
            } else {
                gameResult
            }

            Spacer()
        }
        .padding(.horizontal)
        .padding(.bottom, 8)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .overlay {
            if showPauseMenu {
                PauseOverlayView(isPresented: $showPauseMenu) {
                    NotificationCenter.default.post(name: .navigateToHome, object: nil)
                }
            }
        }
    }

    private var header: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.session.guesserName)
                    .font(AppTheme.font(size: 22))
                    .bodyStyle()
                Text("Round \(viewModel.session.round)")
                    .font(AppTheme.font(size: 14))
                    .secondaryStyle()
            }

            Spacer()

            Text("\(viewModel.wrongGuessCount)/6")
                .font(AppTheme.font(size: 22))
                .bodyStyle()

            Button {
                showPauseMenu = true
            } label: {
                Text("X")
                    .font(AppTheme.font(size: 22))
                    .secondaryStyle()
            }
            .buttonStyle(.plain)
            .padding(.leading, 12)
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
                Text("\(viewModel.session.guesserName) WON")
                    .font(AppTheme.font(size: 38))
                    .headlineStyle()
            } else {
                Text("\(viewModel.session.guesserName) LOST")
                    .font(AppTheme.font(size: 38))
                    .headlineStyle()
                Text("The word was \(viewModel.targetWord)")
                    .font(AppTheme.font(size: 18))
                    .secondaryStyle()
            }

            Button {
                guard !didContinue else { return }
                didContinue = true
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
