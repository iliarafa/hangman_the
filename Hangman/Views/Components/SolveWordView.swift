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
                TextField("\(wordLength) letters", text: $text)
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .textInputAutocapitalization(.characters)
                    .autocorrectionDisabled()
                    .focused($isFocused)
                    .padding(.horizontal, 12)
                    .padding(.vertical, 10)
                    .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 8))

                Button {
                    let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
                    guard !trimmed.isEmpty else { return }
                    onSubmit(trimmed)
                    text = ""
                    isSolving = false
                } label: {
                    Image(systemName: "return")
                        .font(.system(size: 16, weight: .bold, design: .monospaced))
                        .foregroundStyle(.background)
                        .padding(10)
                        .background(.primary, in: RoundedRectangle(cornerRadius: 8))
                }

                Button {
                    text = ""
                    isSolving = false
                } label: {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold, design: .monospaced))
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
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .foregroundStyle(.primary)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(.primary, lineWidth: 1.5))
            }
        }
    }
}
