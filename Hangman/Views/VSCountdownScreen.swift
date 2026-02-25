import SwiftUI

struct VSCountdownScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let word: String
    let onComplete: () -> Void

    @State private var countdown = 3

    var body: some View {
        VStack(spacing: 40) {
            Spacer()

            Text("Pass the device to")
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(viewModel.session.guesserName)
                .font(.system(size: 32, weight: .black, design: .monospaced))

            Text("\(countdown)")
                .font(.system(size: 96, weight: .black, design: .monospaced))
                .contentTransition(.numericText())

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
