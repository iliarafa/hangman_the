import SwiftUI

struct MessageResultView: View {
    let gameState: MessageGameState

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            if gameState.won {
                Text("GUESSED IT!")
                    .font(AppTheme.font(size: 36))
                    .headlineStyle()
            } else {
                Text("FAILED")
                    .font(AppTheme.font(size: 36))
                    .headlineStyle()
            }

            Text("The word was \(gameState.targetWord.uppercased())")
                .font(AppTheme.font(size: 18))
                .bodyStyle()

            ASCIIDivider()

            Text("Send a new word to play again")
                .font(AppTheme.font(size: 14))
                .tertiaryStyle()

            Spacer()
        }
        .padding()
    }
}
