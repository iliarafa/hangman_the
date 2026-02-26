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
        let isRevealedOnLose = char == nil && revealChar != nil

        VStack(spacing: 4) {
            Text(displayChar.map { String($0) } ?? " ")
                .font(AppTheme.font(size: 32))
                .frame(minHeight: 36)
                .foregroundStyle(.primary.opacity(
                    isRevealedOnLose ? AppTheme.tertiaryOpacity : (displayChar != nil ? AppTheme.headlineOpacity : 0)
                ))
                .animation(.easeIn(duration: 0.2), value: char != nil)

            Rectangle()
                .fill(.primary.opacity(AppTheme.bodyOpacity))
                .frame(height: 2)
        }
        .frame(width: 28)
        .fixedSize(horizontal: false, vertical: true)
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
