import SwiftUI

struct GameScreen: View {
    @Bindable var viewModel: GameViewModel
    var playEntryTransition: Bool = false
    @Environment(\.dismiss) private var dismiss
    @State private var showPauseMenu = false
    @State private var showRetreat = false

    var body: some View {
        VStack(spacing: 16) {
            header

            Spacer()

            hangmanArea
            wordArea

            if viewModel.gameStatus == .playing || viewModel.isLoading {
                KeyboardView(
                    letterState: { viewModel.letterState($0) },
                    onTap: { viewModel.guess(letter: $0) }
                )
                .disabled(viewModel.gameStatus != .playing || viewModel.isLoading)

                HStack(spacing: 16) {
                    SolveWordView(
                        wordLength: viewModel.targetWord.count,
                        onSubmit: { viewModel.guessWord($0) }
                    )

                    Button {
                        viewModel.useHint()
                    } label: {
                        Text("HINT")
                            .asciiBracket(.secondary, fontSize: 16)
                            .opacity(viewModel.hintsRemaining > 0 ? 1 : 0.3)
                    }
                    .disabled(viewModel.hintsRemaining == 0)
                    .accessibilityLabel("Hint")
                    .accessibilityHint("Reveals one letter")
                }
                .disabled(viewModel.gameStatus != .playing || viewModel.isLoading)
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
            if viewModel.gameStatus == .won {
                ConfettiView()
                    .ignoresSafeArea()
            }
        }
        .overlay {
            if showPauseMenu {
                PauseOverlayView(isPresented: $showPauseMenu) {
                    NotificationCenter.default.post(name: .navigateToHome, object: nil)
                }
            }
        }
        .overlay {
            if showRetreat {
                PixelFloodView(phase: .retreating) {
                    showRetreat = false
                }
            }
        }
        .onAppear {
            if playEntryTransition {
                showRetreat = true
            }
        }
    }

    private var header: some View {
        ZStack {
            VStack(spacing: 2) {
                Text("\(viewModel.wrongGuessCount)/\(viewModel.difficulty.maxWrongGuesses)")
                    .font(AppTheme.font(size: 22))
                    .bodyStyle()
                    .accessibilityLabel("\(viewModel.wrongGuessCount) of \(viewModel.difficulty.maxWrongGuesses) wrong guesses")

                if viewModel.isOffline {
                    Text("OFFLINE")
                        .font(AppTheme.font(size: 12))
                        .tertiaryStyle()
                }
            }

            HStack {
                Button {
                    showPauseMenu = true
                } label: {
                    Text("X")
                        .font(AppTheme.font(size: 22))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                .padding(.leading, 4)
                .accessibilityLabel("Pause game")

                Spacer()

                Text("\(viewModel.scores.currentStreak)")
                    .font(AppTheme.font(size: 22))
                    .bodyStyle()
                    .accessibilityLabel("Current streak: \(viewModel.scores.currentStreak)")
            }
        }
        .padding(.top, 8)
    }

    private var hangmanArea: some View {
        ASCIIHangman(wrongGuessCount: viewModel.wrongGuessCount, maxWrongGuesses: viewModel.difficulty.maxWrongGuesses)
            .frame(maxHeight: 280)
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

    private var gameResult: some View {
        VStack(spacing: 16) {
            if viewModel.gameStatus == .won {
                Text(ASCIIArt.trophy)
                    .font(AppTheme.font(size: 14))
                    .secondaryStyle()
                    .multilineTextAlignment(.center)

                Text("YOU WON")
                    .font(AppTheme.font(size: 38))
                    .headlineStyle()
                Text("Streak: \(viewModel.scores.currentStreak)")
                    .font(AppTheme.font(size: 18))
                    .secondaryStyle()
            } else {
                Text(ASCIIArt.skull)
                    .font(AppTheme.font(size: 14))
                    .secondaryStyle()
                    .multilineTextAlignment(.center)

                Text("GAME OVER")
                    .font(AppTheme.font(size: 38))
                    .headlineStyle()
                Text("The word was \(viewModel.targetWord)")
                    .font(AppTheme.font(size: 18))
                    .secondaryStyle()
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
