import SwiftUI

struct GameScreen: View {
    @Bindable var viewModel: GameViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showOverlay = false
    @State private var shakeOffset: CGFloat = 0

    var body: some View {
        ZStack {
            backgroundGradient

            VStack(spacing: 16) {
                header
                hangmanArea
                wordArea
                keyboardArea
            }
            .padding(.horizontal)
            .padding(.bottom, 8)

            if viewModel.gameStatus == .won {
                ConfettiView()
                    .ignoresSafeArea()
            }

            if showOverlay {
                gameOverOverlay
            }
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.startNewGame()
        }
        .onChange(of: viewModel.gameStatus) { _, newStatus in
            if newStatus == .won || newStatus == .lost {
                withAnimation(.spring(duration: 0.5)) {
                    showOverlay = true
                }
                if newStatus == .lost {
                    shakeAnimation()
                }
            }
        }
    }

    private var backgroundGradient: some View {
        LinearGradient(
            colors: [Color.blue.opacity(0.08), Color.purple.opacity(0.08)],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .ignoresSafeArea()
    }

    private var header: some View {
        HStack {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(.primary)
            }

            Spacer()

            HStack(spacing: 4) {
                ForEach(0..<6, id: \.self) { index in
                    Circle()
                        .fill(index < viewModel.wrongGuessCount ? Color.red : Color.gray.opacity(0.3))
                        .frame(width: 10, height: 10)
                        .animation(.easeInOut(duration: 0.3), value: viewModel.wrongGuessCount)
                }
            }

            Spacer()

            Text("\(viewModel.scores.currentStreak) \(Image(systemName: "flame.fill"))")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.orange)
        }
        .padding(.top, 8)
    }

    private var hangmanArea: some View {
        HangmanFigure(wrongGuessCount: viewModel.wrongGuessCount)
            .frame(maxHeight: 220)
            .padding(.vertical, 8)
            .offset(x: shakeOffset)
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
        KeyboardView(
            letterState: { viewModel.letterState($0) },
            onTap: { viewModel.guess(letter: $0) }
        )
        .disabled(viewModel.gameStatus != .playing || viewModel.isLoading)
        .opacity(viewModel.gameStatus != .playing ? 0.5 : 1)
    }

    private var gameOverOverlay: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
                .onTapGesture {} // block taps

            VStack(spacing: 20) {
                if viewModel.gameStatus == .won {
                    winContent
                } else {
                    loseContent
                }

                HStack(spacing: 16) {
                    Button(action: {
                        dismiss()
                    }) {
                        Label("Home", systemImage: "house.fill")
                            .font(.system(.body, design: .rounded, weight: .semibold))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
                    }

                    Button(action: {
                        showOverlay = false
                        Task {
                            await viewModel.startNewGame()
                        }
                    }) {
                        Label("Play Again", systemImage: "arrow.counterclockwise")
                            .font(.system(.body, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    colors: [.blue, .purple],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ),
                                in: RoundedRectangle(cornerRadius: 16)
                            )
                    }
                }
            }
            .padding(32)
            .background(.ultraThickMaterial, in: RoundedRectangle(cornerRadius: 24))
            .shadow(radius: 20)
            .padding(24)
            .transition(.scale.combined(with: .opacity))
        }
    }

    private var winContent: some View {
        VStack(spacing: 12) {
            Text("You Won!")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.green, .mint],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )

            Text("The word was **\(viewModel.targetWord)**")
                .font(.system(.title3, design: .rounded))

            Text("Streak: \(viewModel.scores.currentStreak) \(Image(systemName: "flame.fill"))")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(.orange)
        }
    }

    private var loseContent: some View {
        VStack(spacing: 12) {
            Text("Game Over")
                .font(.system(size: 36, weight: .black, design: .rounded))
                .foregroundStyle(.red)

            Text("The word was **\(viewModel.targetWord)**")
                .font(.system(.title3, design: .rounded))
        }
    }

    private func shakeAnimation() {
        let offsets: [CGFloat] = [0, -15, 15, -10, 10, -5, 5, 0]
        for (index, offset) in offsets.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.06) {
                withAnimation(.easeInOut(duration: 0.06)) {
                    shakeOffset = offset
                }
            }
        }
    }
}
