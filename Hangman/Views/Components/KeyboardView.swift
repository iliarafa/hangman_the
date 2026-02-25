import AudioToolbox
import SwiftUI

struct KeyboardView: View {
    let letterState: (Character) -> LetterState
    let onTap: (Character) -> Void

    private let letters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let slotWidth: CGFloat = 44 // 38pt button + 6pt spacing

    @State private var lastSlotIndex: Int = 0
    @State private var lastTickTime: Date = .distantPast
    @State private var feedbackGenerator = UISelectionFeedbackGenerator()

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 6) {
                ForEach(letters, id: \.self) { letter in
                    LetterButton(
                        letter: letter,
                        state: letterState(letter),
                        action: { onTap(letter) }
                    )
                }
            }
            .padding(.horizontal, 8)
            .background(
                GeometryReader { geo in
                    Color.clear.preference(
                        key: ScrollOffsetKey.self,
                        value: geo.frame(in: .named("keyboard")).minX
                    )
                }
            )
        }
        .coordinateSpace(name: "keyboard")
        .onPreferenceChange(ScrollOffsetKey.self) { offset in
            let slotIndex = Int(round(-offset / slotWidth))
            guard slotIndex != lastSlotIndex else { return }

            let now = Date()
            guard now.timeIntervalSince(lastTickTime) >= 0.03 else { return }

            lastSlotIndex = slotIndex
            lastTickTime = now
            feedbackGenerator.selectionChanged()
            AudioServicesPlaySystemSound(1104)
        }
        .onAppear {
            feedbackGenerator.prepare()
        }
    }
}

private struct ScrollOffsetKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    KeyboardView(
        letterState: { _ in .unused },
        onTap: { _ in }
    )
}
