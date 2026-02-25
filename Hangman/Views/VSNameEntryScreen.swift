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
            Text("VS MODE")
                .font(.system(size: 42, weight: .black, design: .monospaced))

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
        .padding(.horizontal, 20)
    }

    private func nameField(placeholder: String, text: Binding<String>) -> some View {
        TextField(placeholder, text: text)
            .font(.system(size: 18, design: .monospaced))
            .textInputAutocapitalization(.words)
            .autocorrectionDisabled()
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.primary.opacity(0.3), lineWidth: 1)
            )
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
                .font(.system(size: 24, weight: .bold, design: .monospaced))
                .foregroundStyle(.background)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 18)
                .background(
                    canStart ? Color.primary : Color.primary.opacity(0.3),
                    in: RoundedRectangle(cornerRadius: 8)
                )
        }
        .disabled(!canStart)
        .padding(.horizontal, 20)
    }

    private var backButton: some View {
        Button {
            dismiss()
        } label: {
            Text("Back")
                .font(.system(size: 16, design: .monospaced))
                .foregroundStyle(.secondary)
                .underline()
        }
        .padding(.bottom, 8)
    }
}
