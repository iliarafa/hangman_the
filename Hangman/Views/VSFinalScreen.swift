import SwiftUI

struct VSFinalScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onHome: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            resultSection
            finalScoreboard
            Spacer()
            homeButton
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    private var resultSection: some View {
        VStack(spacing: 12) {
            if let winner = viewModel.session.winnerName {
                Text("\(winner) WINS")
                    .font(.system(size: 34, weight: .black, design: .monospaced))
            } else {
                Text("IT'S A TIE")
                    .font(.system(size: 34, weight: .black, design: .monospaced))
            }

            Text("\(viewModel.session.round - 1) rounds played")
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }

    private var finalScoreboard: some View {
        HStack(spacing: 32) {
            playerFinalScore(
                name: viewModel.session.player1Name,
                score: viewModel.session.player1Score,
                isWinner: viewModel.session.winnerName == viewModel.session.player1Name
            )

            Text("—")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.secondary)

            playerFinalScore(
                name: viewModel.session.player2Name,
                score: viewModel.session.player2Score,
                isWinner: viewModel.session.winnerName == viewModel.session.player2Name
            )
        }
    }

    private func playerFinalScore(name: String, score: Int, isWinner: Bool) -> some View {
        VStack(spacing: 8) {
            if isWinner {
                Text("*")
                    .font(.system(size: 24, weight: .bold, design: .monospaced))
            }

            Text("\(score)")
                .font(.system(size: 52, weight: .black, design: .monospaced))

            Text(name)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .lineLimit(1)
        }
        .frame(minWidth: 80)
    }

    private var homeButton: some View {
        Button(action: onHome) {
            Text("HOME")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(.primary, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 20)
    }
}
