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
                Text(ASCIIArt.trophy)
                    .font(AppTheme.font(size: 14))
                    .secondaryStyle()
                    .multilineTextAlignment(.center)

                ASCIITitleBox("\(winner) WINS", charWidth: 24)
            } else {
                ASCIITitleBox("IT'S A TIE", charWidth: 24)
            }

            Text("\(viewModel.session.round - 1) rounds played")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
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
                .font(AppTheme.font(size: 28))
                .secondaryStyle()

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
                Text(">>>")
                    .font(AppTheme.font(size: 18))
                    .secondaryStyle()
            }

            Text("\(score)")
                .font(AppTheme.font(size: 60))
                .headlineStyle()

            Text(name)
                .font(AppTheme.font(size: 18))
                .bodyStyle()
                .lineLimit(1)
        }
        .frame(minWidth: 80)
    }

    private var homeButton: some View {
        Button(action: onHome) {
            Text("HOME")
                .asciiBracket(.primary, fontSize: 24)
        }
    }
}
