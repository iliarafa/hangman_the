import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var stage = 0 // 0 = gallows only, 1-6 = body parts, 7 = empty + button

    // Each line is exactly 9 characters wide to prevent jitter
    private let stages: [(art: String, text: String?)] = [
        // 0: empty gallows
        ("┌──────┐\n│      │\n│       \n│       \n│       \n│       \n═════════", nil),
        // 1: head
        ("┌──────┐\n│      │\n│      O\n│       \n│       \n│       \n═════════", "WELCOME TO GALLOWS & FRIENDS"),
        // 2: body
        ("┌──────┐\n│      │\n│      O\n│      |\n│       \n│       \n═════════", "PICK LETTERS TO GUESS THE WORD"),
        // 3: left arm
        ("┌──────┐\n│      │\n│      O\n│     /|\n│       \n│       \n═════════", "ARCADE OR PASS & PLAY MODE"),
        // 4: right arm
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│       \n│       \n═════════", "CUSTOMIZE EXPERIENCE IN SETTINGS"),
        // 5: left leg
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│     / \n│       \n═════════", "ESCAPE THE ROPE"),
        // 6: right leg (full body)
        ("┌──────┐\n│      │\n│      O\n│     /|\\\n│     / \\\n│       \n═════════", "ESCAPE"),
        // 7: empty gallows — figure has escaped, button appears
        ("┌──────┐\n│      │\n│       \n│       \n│       \n│       \n═════════", nil),
    ]

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Text(stages[min(stage, 7)].art)
                .font(AppTheme.font(size: 24))
                .bodyStyle()
                .lineSpacing(2)
                .multilineTextAlignment(.leading)
                .fixedSize()
                .animation(nil, value: stage)

            Text(stages[min(stage, 7)].text ?? " ")
                .font(AppTheme.font(size: 20))
                .headlineStyle()
                .opacity(stages[min(stage, 7)].text == nil ? 0 : 1)
                .transition(.opacity)
                .id(stages[min(stage, 7)].text ?? "empty")

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
        // Show empty gallows first, then reveal each limb, then clear to empty + button
        let delays: [Double] = [0.8, 2.8, 4.8, 6.8, 8.8, 10.8, 12.8, 14.8]
        for (i, delay) in delays.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                withAnimation(.easeOut(duration: 0.4)) {
                    stage = i + 1
                }
            }
        }
    }
}
