import AudioToolbox
import SwiftUI

struct KeyboardView: View {
    let letterState: (Character) -> LetterState
    let onTap: (Character) -> Void

    private let letters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

    @State private var scrolledID: Character?
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
            .scrollTargetLayout()
            .padding(.horizontal, 8)
        }
        .scrollPosition(id: $scrolledID)
        .scrollTargetBehavior(.viewAligned)
        .onChange(of: scrolledID) {
            feedbackGenerator.selectionChanged()
            AudioServicesPlaySystemSound(1104)
            feedbackGenerator.prepare()
        }
        .onAppear {
            feedbackGenerator.prepare()
        }
    }
}


#Preview {
    KeyboardView(
        letterState: { _ in .unused },
        onTap: { _ in }
    )
}
