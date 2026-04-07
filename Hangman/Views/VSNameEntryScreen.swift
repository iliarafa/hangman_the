import SwiftUI

struct VSNameEntryScreen: View {
    let soundManager: SoundManager
    let onStart: (VSGameViewModel) -> Void

    @State private var player1Name = ""
    @State private var player2Name = ""
    @State private var selectedRounds = 0 // 0 = unlimited
    @Environment(\.dismiss) private var dismiss

    private let roundOptions = [0, 3, 5, 7]

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
            roundPicker
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

    private var roundPicker: some View {
        VStack(spacing: 8) {
            Text("Rounds")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()

            HStack(spacing: 16) {
                ForEach(roundOptions, id: \.self) { count in
                    Button {
                        selectedRounds = count
                    } label: {
                        Text(count == 0 ? "∞" : "\(count)")
                            .font(AppTheme.font(size: 20))
                            .foregroundStyle(.primary.opacity(
                                selectedRounds == count ? AppTheme.headlineOpacity : AppTheme.tertiaryOpacity
                            ))
                    }
                    .buttonStyle(.plain)
                }
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
                soundManager: soundManager,
                totalRounds: selectedRounds
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
