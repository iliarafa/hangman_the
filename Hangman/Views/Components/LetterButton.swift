import SwiftUI

struct LetterButton: View {
    let letter: Character
    let state: LetterState
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(String(letter))
                .font(.system(size: 18, weight: .bold, design: .monospaced))
                .strikethrough(state == .wrong)
                .foregroundStyle(.primary)
                .opacity(state == .unused ? 1 : 0.25)
                .frame(width: 38, height: 42)
        }
        .disabled(state != .unused)
        .sensoryFeedback(.impact(flexibility: .soft), trigger: state)
    }
}

#Preview {
    HStack {
        LetterButton(letter: "A", state: .unused) {}
        LetterButton(letter: "B", state: .correct) {}
        LetterButton(letter: "C", state: .wrong) {}
    }
}
