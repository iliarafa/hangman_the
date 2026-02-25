import SwiftUI

struct VSNameEntryScreen: View {
    let soundManager: SoundManager
    let onStart: (VSGameViewModel) -> Void

    @State private var player1Name = ""
    @State private var player2Name = ""
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            titleSection
            nameFields
            startButton
            Spacer()
            backButton
        }
        .padding()
        .navigationBarBackButtonHidden(true)
    }

    private var titleSection: some View {
        VStack(spacing: 8) {
            ASCIITitleBox("VS MODE", charWidth: 20)

            Text("Enter player names")
                .font(.system(size: 14, design: .monospaced))
                .foregroundStyle(.secondary)
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
                .opacity(canStart ? 1 : 0.3)
        }
        .disabled(!canStart)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Back")
                .asciiBracket(.secondary, fontSize: 16)
        }
        .padding(.bottom, 8)
    }
}
