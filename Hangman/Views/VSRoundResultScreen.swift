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
            ASCIITitleBox("SCOREBOARD", charWidth: 22)

            HStack(spacing: 32) {
                playerScore(
                    name: viewModel.session.player1Name,
                    score: viewModel.session.player1Score
                )

                Text("vs")
                    .font(AppTheme.font(size: 22))
                    .secondaryStyle()

                playerScore(
                    name: viewModel.session.player2Name,
                    score: viewModel.session.player2Score
                )
            }

            Text("Round \(viewModel.session.round - 1) complete")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
        }
    }

    private func playerScore(name: String, score: Int) -> some View {
        VStack(spacing: 8) {
            Text("\(score)")
                .font(AppTheme.font(size: 56))
                .headlineStyle()

            Text(name)
                .font(AppTheme.font(size: 18))
                .bodyStyle()
                .lineLimit(1)
        }
        .frame(minWidth: 80)
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            Button(action: onNextRound) {
                Text("NEXT ROUND")
                    .asciiBracket(.primary, fontSize: 20)
            }

            Button(action: onEndGame) {
                Text("End Game")
                    .asciiBracket(.secondary, fontSize: 16)
            }
        }
    }
}
