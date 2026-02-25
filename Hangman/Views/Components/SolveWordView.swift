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
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(.secondary)
                    TextField("\(wordLength) letters", text: $text)
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .textInputAutocapitalization(.characters)
                        .autocorrectionDisabled()
                        .focused($isFocused)
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 10)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(Color.secondary.opacity(0.3))
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
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(.background)
                        .padding(10)
                        .background(.primary)
                }

                Button {
                    text = ""
                    isSolving = false
                } label: {
                    Text("x")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(.secondary)
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
