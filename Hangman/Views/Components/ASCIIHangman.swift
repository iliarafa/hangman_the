import SwiftUI

struct ASCIIHangman: View {
    let wrongGuessCount: Int
    var maxWrongGuesses: Int = 6

    private var stage: Int {
        guard maxWrongGuesses > 0 else { return 0 }
        return min(6, wrongGuessCount * 6 / maxWrongGuesses)
    }

    private var art: String {
        states[stage]
    }

    var body: some View {
        Text(art)
            .font(AppTheme.font(size: 24))
            .bodyStyle()
            .lineSpacing(2)
            .multilineTextAlignment(.leading)
            .accessibilityElement(children: .ignore)
            .accessibilityLabel("Hangman drawing, \(wrongGuessCount) of \(maxWrongGuesses) wrong guesses")
    }

    private let states = [
        // 0 wrong
        """
        ┌──────┐
        │      │
        │
        │
        │
        │
        ═════════
        """,
        // 1 wrong
        """
        ┌──────┐
        │      │
        │      O
        │
        │
        │
        ═════════
        """,
        // 2 wrong
        """
        ┌──────┐
        │      │
        │      O
        │      |
        │
        │
        ═════════
        """,
        // 3 wrong
        """
        ┌──────┐
        │      │
        │      O
        │     /|
        │
        │
        ═════════
        """,
        // 4 wrong
        """
        ┌──────┐
        │      │
        │      O
        │     /|\\
        │
        │
        ═════════
        """,
        // 5 wrong
        """
        ┌──────┐
        │      │
        │      O
        │     /|\\
        │     /
        │
        ═════════
        """,
        // 6 wrong
        """
        ┌──────┐
        │      │
        │      O
        │     /|\\
        │     / \\
        │
        ═════════
        """
    ]
}

#Preview {
    VStack {
        ForEach(0..<7, id: \.self) { count in
            ASCIIHangman(wrongGuessCount: count)
                .padding(.bottom, 8)
        }
    }
}
