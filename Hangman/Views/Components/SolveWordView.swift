import SwiftUI

struct SolveWordView: View {
    let wordLength: Int
    let onSubmit: (String) -> Void

    @State private var isSolving = false
    @State private var text = ""
    @FocusState private var isFocused: Bool

    var body: some View {
        if isSolving {
            HStack(spacing: 8) {
                HStack(spacing: 0) {
                    Text("> ")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                    TextField("\(wordLength) letters", text: $text)
                        .font(AppTheme.font(size: 18))
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .focused($isFocused)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.primary.opacity(AppTheme.tertiaryOpacity))
                        .frame(height: 1)
                }

                Button {
                    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    onSubmit(trimmed)
                    text = ""
                    isSolving = false
                } label: {
                    Text(">")
                        .font(AppTheme.font(size: 18))
                        .foregroundStyle(.background)
                        .padding(10)
                        .background(.primary)
                }

                Button {
                    text = ""
                    isSolving = false
                } label: {
                    Text("x")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                        .padding(10)
                }
            }
            .onAppear { isFocused = true }
        } else {
            Button {
                isSolving = true
            } label: {
                Text("SOLVE")
                    .asciiBracket(.secondary, fontSize: 16)
            }
        }
    }
}
