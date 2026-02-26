import SwiftUI

struct VSWordEntryScreen: View {
    @Bindable var viewModel: VSGameViewModel
    let onReady: (String) -> Void
    let onBack: () -> Void

    @State private var word = ""
    @State private var errorMessage = ""
    @State private var didSubmit = false

    var body: some View {
        VStack(spacing: 32) {
            HStack {
                Button {
                    onBack()
                } label: {
                    Text("< BACK")
                        .font(AppTheme.font(size: 16))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                Spacer()
            }

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
            didSubmit = false
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
            guard !didSubmit else { return }
            if viewModel.validateWord(word) {
                didSubmit = true
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
        viewModel.wordValidationError(word) ?? ""
    }
}
