import SwiftUI

struct VSCountdownScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let word: String
    let onComplete: () -> Void

    @State private var countdown = 3
    @State private var countdownTask: Task<Void, Never>?

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            ASCIIDivider()

            Text("Pass the device to")
                .font(AppTheme.font(size: 18))
                .secondaryStyle()

            Text(viewModel.session.guesserName)
                .font(AppTheme.font(size: 38))
                .headlineStyle()

            Text("\(countdown)")
                .font(AppTheme.font(size: 108))
                .headlineStyle()
                .contentTransition(.numericText())

            ASCIIDivider()

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            viewModel.startRound(word: word)
            startCountdown()
        }
        .onDisappear {
            countdownTask?.cancel()
        }
    }

    private func startCountdown() {
        countdownTask = Task { @MainActor in
            for tick in 0..<3 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                withAnimation {
                    countdown = 2 - tick
                }
            }
            guard !Task.isCancelled else { return }
            onComplete()
        }
    }
}
