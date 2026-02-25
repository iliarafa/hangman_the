import SwiftUI

struct ASCIIHangman: View {
    let wrongGuessCount: Int

    private var art: String {
        states[min(wrongGuessCount, 6)]
    }

    var body: some View {
        Text(art)
            .font(AppTheme.font(size: 18))
            .bodyStyle()
            .lineSpacing(2)
            .multilineTextAlignment(.leading)
    }

    private let states = [
        // 0 wrong
        """
         ______
        |      |
        |
        |
        |
        |
        =========
        """,
        // 1 wrong
        """
         ______
        |      |
        |      O
        |
        |
        |
        =========
        """,
        // 2 wrong
        """
         ______
        |      |
        |      O
        |      |
        |
        |
        =========
        """,
        // 3 wrong
        """
         ______
        |      |
        |      O
        |     /|
        |
        |
        =========
        """,
        // 4 wrong
        """
         ______
        |      |
        |      O
        |     /|\\
        |
        |
        =========
        """,
        // 5 wrong
        """
         ______
        |      |
        |      O
        |     /|\\
        |     /
        |
        =========
        """,
        // 6 wrong
        """
         ______
        |      |
        |      O
        |     /|\\
        |     / \\
        |
        =========
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
