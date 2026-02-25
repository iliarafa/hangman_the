import SwiftUI

struct KeyboardView: View {
    let letterState: (Character) -> LetterState
    let onTap: (Character) -> Void

    private let letters: [Character] = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ")
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 7)

    var body: some View {
        LazyVGrid(columns: columns, spacing: 6) {
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

#Preview {
    KeyboardView(
        letterState: { _ in .unused },
        onTap: { _ in }
    )
}
