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
            ASCIITitleBox("SCOREBOARD")

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

            Text(roundLabel)
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

    private var roundLabel: String {
        let completed = viewModel.session.round - 1
        if viewModel.session.totalRounds > 0 {
            return "Round \(completed) of \(viewModel.session.totalRounds)"
        }
        return "Round \(completed) complete"
    }

    private var actionButtons: some View {
        VStack(spacing: 16) {
            if viewModel.session.isComplete {
                Button(action: onEndGame) {
                    Text("SEE RESULTS")
                        .asciiBracket(.primary, fontSize: 20)
                }
            } else {
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
}
