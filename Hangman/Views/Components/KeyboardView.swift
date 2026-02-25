import SwiftUI

struct KeyboardView: View {
    let letterState: (Character) -> LetterState
    let onTap: (Character) -> Void

    private let letters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")

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
        }
    }
}

#Preview {
    KeyboardView(
        letterState: { _ in .unused },
        onTap: { _ in }
    )
}
