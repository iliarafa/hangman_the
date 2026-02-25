import SwiftUI

struct LetterButton: View {
    let letter: Character
    let state: LetterState
    let action: () -> Void

    private var backgroundColor: Color {
        switch state {
        case .unused: return .blue.opacity(0.15)
        case .correct: return .green.opacity(0.8)
        case .wrong: return .red.opacity(0.8)
        }
    }

    private var foregroundColor: Color {
        switch state {
        case .unused: return .primary
        case .correct, .wrong: return .white
        }
    }

    var body: some View {
        Button(action: action) {
            Text(String(letter))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(foregroundColor)
                .frame(width: 38, height: 42)
                .background(backgroundColor, in: RoundedRectangle(cornerRadius: 8))
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
