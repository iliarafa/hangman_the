import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stage = 0 // 0 = gallows only, 1-6 = body parts, 7 = button

    // Each line is exactly 9 characters wide to prevent jitter
    private let stages: [(art: String, text: String?)] = [
        // 0: empty gallows
        ("┌──────┐\n│      │\n│       \n│       \n│       \n│       \n═════════", nil),
        // 1: head
        ("┌──────┐\n│      │\n│      O\n│       \n│       \n│       \n═════════", "LETTER BY LETTER"),
        // 2: body
        ("┌──────┐\n│      │\n│      O\n│      |\n│       \n│       \n═════════", "GUESSING THE WORD"),
        // 3: left arm
        ("┌──────┐\n│      │\n│      O\n│     /|\n│       \n│       \n═════════", "I'M CHOOSING WISELY"),
        // 4: right arm
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│       \n│       \n═════════", "CAUSE I CAN'T GO WRONG"),
        // 5: left leg
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│     / \n│       \n═════════", "YOU BLINK, I DO NOT"),
        // 6: right leg (full body)
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│     / \\\n│       \n═════════", "THE HANGMAN IS GONE"),
    ]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text(stages[min(stage, 6)].art)
                .font(AppTheme.font(size: 24))
                .bodyStyle()
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
                .fixedSize()
                .animation(nil, value: stage)

            if let text = stages[min(stage, 6)].text {
                Text(text)
                    .font(AppTheme.font(size: 20))
                    .headlineStyle()
                    .transition(.opacity)
                    .id(text)
            }

            Spacer()

            Button {
                onComplete()
            } label: {
                Text("LET'S PLAY")
                    .asciiBracket(.primary, fontSize: 24)
            }
            .opacity(stage >= 7 ? 1 : 0)
            .allowsHitTesting(stage >= 7)

            Spacer()
        }
        .padding()
        .onAppear {
            if reduceMotion {
                stage = 7
            } else {
                runAnimation()
            }
        }
    }

    private func runAnimation() {
        // Show empty gallows first, then reveal each limb
        let delays: [Double] = [0.8, 2.8, 4.8, 6.8, 8.8, 10.8, 12.8]
        for (i, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.4)) {
                    stage = i + 1
                }
            }
        }
    }
}
