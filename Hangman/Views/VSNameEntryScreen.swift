import SwiftUI

struct VSNameEntryScreen: View {
    let soundManager: SoundManager
    let onStart: (VSGameViewModel) -> Void

    @State private var player1Name = ""
    @State private var player2Name = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Button {
                    withoutNavAnimation { dismiss() }
                } label: {
                    Text("< BACK")
                        .font(AppTheme.font(size: 18))
                        .secondaryStyle()
                }
                .buttonStyle(.plain)
                Spacer()
            }

            Spacer()
            titleSection
            Spacer()
            nameFields
            Spacer()
            startButton
            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            ASCIITitleBox("VS MODE")

            Text("Enter player names")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
        }
    }

    private var nameFields: some View {
        VStack(spacing: 16) {
            nameField(placeholder: "Player 1", text: $player1Name)
            nameField(placeholder: "Player 2", text: $player2Name)
        }
    }

    private func nameField(placeholder: String, text: Binding<String>) -> some View {
        ASCIITextField(placeholder: placeholder, text: text, slotCount: 12)
            .onChange(of: text.wrappedValue) { _, newValue in
                let filtered = String(newValue.filter { $0.isLetter || $0 == " " })
                if filtered != newValue {
                    text.wrappedValue = filtered
                }
            }
    }

    private var canStart: Bool {
        !player1Name.trimmingCharacters(in: .whitespaces).isEmpty &&
        !player2Name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private var startButton: some View {
        Button {
            let vm = VSGameViewModel(
                player1: player1Name.trimmingCharacters(in: .whitespaces),
                player2: player2Name.trimmingCharacters(in: .whitespaces),
                soundManager: soundManager
            )
            onStart(vm)
        } label: {
            Text("START")
                .asciiBracket(.primary, fontSize: 24)
                .foregroundStyle(Color(red: 0.0, green: 0.5, blue: 0.0))
                .opacity(canStart ? 1 : 0.3)
        }
        .disabled(!canStart)
    }

}
