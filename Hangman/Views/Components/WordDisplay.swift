import SwiftUI

struct WordDisplay: View {
    let displayWord: [Character?]
    let revealWord: String?

    init(displayWord: [Character?], revealWord: String? = nil) {
        self.displayWord = displayWord
        self.revealWord = revealWord
    }

    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(displayWord.enumerated()), id: \.offset) { index, char in
                letterBox(char: char, revealChar: revealCharAt(index))
            }
        }
    }

    @ViewBuilder
    private func letterBox(char: Character?, revealChar: Character?) -> some View {
        let displayChar = char ?? revealChar
        let isRevealed = char != nil
        let isRevealedOnLose = char == nil && revealChar != nil

        VStack(spacing: 2) {
            Text(displayChar.map { String($0) } ?? " ")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(isRevealedOnLose ? .red : .primary)
                .opacity(displayChar != nil ? 1 : 0)
                .animation(.easeIn(duration: 0.2), value: isRevealed)

            Rectangle()
                .fill(Color.primary.opacity(0.3))
                .frame(height: 3)
                .frame(width: 28)
        }
        .frame(width: 32, height: 44)
    }

    private func revealCharAt(_ index: Int) -> Character? {
        guard let word = revealWord else { return nil }
        let chars = Array(word.uppercased())
        guard index < chars.count else { return nil }
        return chars[index]
    }
}

#Preview {
    VStack(spacing: 20) {
        WordDisplay(displayWord: [Character("H"), nil, Character("L"), nil, Character("O")])
        WordDisplay(displayWord: [nil, nil, nil, nil, nil], revealWord: "HELLO")
    }
}
