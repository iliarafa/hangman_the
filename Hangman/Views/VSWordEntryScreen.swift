import SwiftUI

struct VSWordEntryScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onReady: (String) -> Void

    @State private var word = ""
    @State private var errorMessage = ""

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            headerSection
            wordField
            if !errorMessage.isEmpty {
                errorLabel
            }
            readyButton
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .onAppear {
            word = ""
            errorMessage = ""
        }
    }

    private var headerSection: some View {
        VStack(spacing: 8) {
            Text("ROUND \(viewModel.session.round)")
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.secondary)

            Text(viewModel.session.setterName)
                .font(.system(size: 32, weight: .black, design: .monospaced))

            Text("Enter a word for \(viewModel.session.guesserName)")
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
    }

    private var wordField: some View {
        SecureField("Secret word", text: $word)
            .font(.system(size: 18, design: .monospaced))
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.primary.opacity(0.3), lineWidth: 1)
            )
            .padding(.horizontal, 20)
            .onChange(of: word) { _, _ in
                errorMessage = ""
            }
    }

    private var errorLabel: some View {
        Text(errorMessage)
            .font(.system(size: 14, design: .monospaced))
            .foregroundStyle(.red)
    }

    private var readyButton: some View {
        Button {
            if viewModel.validateWord(word) {
                onReady(word)
            } else {
                errorMessage = validationMessage
            }
        } label: {
            Text("READY")
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(.primary, in: RoundedRectangle(cornerRadius: 8))
        }
        .padding(.horizontal, 20)
    }

    private var validationMessage: String {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Please enter a word" }
        if trimmed.count < 2 { return "Word must be at least 2 characters" }
        if trimmed.count > 20 { return "Word must be 20 characters or less" }
        if !trimmed.allSatisfy({ $0.isLetter }) { return "Letters only" }
        return ""
    }
}
