import SwiftUI

struct WordDisplay: View {
    let displayWord: [Character?]
    let revealWord: String?

    init(displayWord: [Character?], revealWord: String? = nil) {
        self.displayWord = displayWord
        self.revealWord = revealWord
    }

    var body: some View {
        GeometryReader { geo in
            let count = max(displayWord.count, 1)
            let totalSpacing = CGFloat(count - 1) * 8
            let slotWidth = min(28, (geo.size.width - totalSpacing) / CGFloat(count))
            HStack(spacing: 8) {
                ForEach(Array(displayWord.enumerated()), id: \.offset) { index, char in
                    letterBox(char: char, revealChar: revealCharAt(index), slotWidth: slotWidth)
                }
            }
            .frame(maxWidth: .infinity)
        }
        .frame(height: 52)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(accessibilityDescription)
    }

    private var accessibilityDescription: String {
        let letters = displayWord.map { char in
            char.map(String.init) ?? "blank"
        }
        return "Word: " + letters.joined(separator: ", ")
    }

    @ViewBuilder
    private func letterBox(char: Character?, revealChar: Character?, slotWidth: CGFloat = 28) -> some View {
        let displayChar = char ?? revealChar
        let isRevealedOnLose = char == nil && revealChar != nil
        let fontSize = min(32, slotWidth * 1.14)

        VStack(spacing: 4) {
            Text(displayChar.map { String($0) } ?? " ")
                .font(AppTheme.font(size: fontSize))
                .frame(minHeight: 36)
                .foregroundStyle(.primary.opacity(
                    isRevealedOnLose ? AppTheme.tertiaryOpacity : (displayChar != nil ? AppTheme.headlineOpacity : 0)
                ))
                .animation(.easeIn(duration: 0.2), value: char != nil)

            Rectangle()
                .fill(.primary.opacity(AppTheme.bodyOpacity))
                .frame(height: 2)
        }
        .frame(width: slotWidth)
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
