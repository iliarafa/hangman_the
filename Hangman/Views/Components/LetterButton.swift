import SwiftUI

struct LetterButton: View {
    let letter: Character
    let state: LetterState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(String(letter))
                .font(AppTheme.font(size: 26))
                .strikethrough(state == .wrong)
                .foregroundStyle(.primary.opacity(state == .unused ? AppTheme.headlineOpacity : AppTheme.tertiaryOpacity))
                .frame(width: 44, height: 48)
        }
        .disabled(state != .unused)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: state)
        .accessibilityLabel(String(letter))
        .accessibilityValue(state == .unused ? "not guessed" : state == .correct ? "correct" : "wrong")
        .accessibilityHint(state == .unused ? "Guess this letter" : "")
    }
}

#Preview {
    HStack {
        LetterButton(letter: "A", state: .unused) {}
        LetterButton(letter: "B", state: .correct) {}
        LetterButton(letter: "C", state: .wrong) {}
    }
}
