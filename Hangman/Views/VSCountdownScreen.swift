import SwiftUI

struct VSCountdownScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let word: String
    let onComplete: () -> Void

    @State private var countdown = 3

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
    }

    private func startCountdown() {
        for tick in 0..<3 {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(tick)) {
                withAnimation {
                    countdown = 3 - tick
                }
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            onComplete()
        }
    }
}
