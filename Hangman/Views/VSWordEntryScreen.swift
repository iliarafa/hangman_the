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
                .font(AppTheme.font(size: 18))
                .secondaryStyle()

            Text(viewModel.session.setterName)
                .font(AppTheme.font(size: 38))
                .headlineStyle()

            Text("Enter a word for \(viewModel.session.guesserName)")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
                .multilineTextAlignment(.center)
        }
    }

    private var wordField: some View {
        ASCIITextField(placeholder: "Secret word", text: $word, slotCount: 12)
            .onChange(of: word) { _, _ in
                errorMessage = ""
            }
    }

    private var errorLabel: some View {
        Text("! " + errorMessage)
            .font(AppTheme.font(size: 16))
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
                .asciiBracket(.primary, fontSize: 24)
        }
    }

    private var validationMessage: String {
        let trimmed = word.trimmingCharacters(in: .whitespaces)
        if trimmed.isEmpty { return "Please enter a word" }
        if trimmed.count < 2 { return "Word must be at least 2 characters" }
        if trimmed.count > 20 { return "Word must be 20 characters or less" }
        if !trimmed.allSatisfy({ $0.isLetter }) { return "Letters only" }
        if !WordValidator.isRealWord(trimmed) { return "Not a recognized word" }
        return ""
    }
}
