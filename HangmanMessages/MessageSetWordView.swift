import SwiftUI

struct MessageSetWordView: View {
    let onSend: (String) -> Void

    @State private var word = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            ASCIITitleBox("SET A WORD")

            Text("Pick a word for your opponent")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()

            ASCIITextField(placeholder: "Secret word", text: $word, slotCount: 12)
                .onChange(of: word) { _, _ in
                    errorMessage = ""
                }

            if !errorMessage.isEmpty {
                Text("! " + errorMessage)
                    .font(AppTheme.font(size: 16))
                    .foregroundStyle(.red)
            }

            Button {
                if let error = validateWord(word) {
                    errorMessage = error
                } else {
                    onSend(word)
                }
            } label: {
                Text("SEND")
                    .asciiBracket(.primary, fontSize: 24)
            }

            Spacer()
        }
        .padding()
    }

    private func validateWord(_ word: String) -> String? {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Please enter a word" }
        if trimmed.count < 2 { return "Word must be at least 2 characters" }
        if trimmed.count > 12 { return "Word must be 12 characters or less" }
        if !trimmed.allSatisfy({ $0.isLetter }) { return "Letters only" }
        if !WordValidator.isRealWord(trimmed) { return "Not a recognized word" }
        return nil
    }
}
