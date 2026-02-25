import SwiftUI

struct VSRoundResultScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onNextRound: () -> Void
    let onEndGame: () -> Void

    var body: some View {
        VStack(spacing: 28) {
            Spacer()
            scoreboard
            Spacer()
            actionButtons
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    private var scoreboard: some View {
        VStack(spacing: 24) {
            Text("SCOREBOARD")
                .font(.system(size: 28, weight: .black, design: .monospaced))

            HStack(spacing: 32) {
                playerScore(
                    name: viewModel.session.player1Name,
                    score: viewModel.session.player1Score
                )

                Text("vs")
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .foregroundStyle(.secondary)

                playerScore(
                    name: viewModel.session.player2Name,
                    score: viewModel.session.player2Score
                )
            }

            Text("Round \(viewModel.session.round - 1) complete")
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.secondary)
        }
    }

    private func playerScore(name: String, score: Int) -> some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(.system(size: 48, weight: .black, design: .monospaced))

            Text(name)
                .font(.system(size: 16, weight: .bold, design: .monospaced))
                .lineLimit(1)
        }
        .frame(minWidth: 80)
    }

    private var actionButtons: some View {
        VStack(spacing: 12) {
            Button(action: onNextRound) {
                Text("NEXT ROUND")
                    .font(.system(size: 20, weight: .bold, design: .monospaced))
                    .foregroundStyle(.background)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(.primary, in: RoundedRectangle(cornerRadius: 8))
            }

            Button(action: onEndGame) {
                Text("End Game")
                    .font(.system(size: 16, design: .monospaced))
                    .foregroundStyle(.secondary)
                    .underline()
                    .padding(.vertical, 12)
            }
        }
        .padding(.horizontal, 20)
    }
}
