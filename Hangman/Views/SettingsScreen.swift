import SwiftUI

struct SettingsScreen: View {
    let scoreManager: ScoreManager
    let soundManager: SoundManager

    @AppStorage("hangman_displayMode") private var displayMode: String = "night"
    @AppStorage("hangman_difficulty") private var difficulty: String = Difficulty.normal.rawValue
    @AppStorage("hangman_wordLength") private var wordLength: String = "any"
    @Environment(\.dismiss) private var dismiss
    @State private var showStats = false

    private let displayModes = ["day", "night", "system"]
    private let wordLengths = ["any", "short", "medium", "long"]

    var body: some View {
        VStack(spacing: 32) {
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

            ASCIITitleBox("SETTINGS")
                .padding(.top, 8)

            Spacer()

            VStack(spacing: 24) {
                settingRow(title: "SOUND") {
                    HStack(spacing: 16) {
                        ForEach(["ON", "OFF"], id: \.self) { option in
                            Button {
                                soundManager.isMuted = (option == "OFF")
                            } label: {
                                Text(option)
                                    .font(AppTheme.font(size: 16))
                                    .foregroundStyle(.primary.opacity(
                                        (option == "ON") == !soundManager.isMuted
                                            ? AppTheme.headlineOpacity
                                            : AppTheme.tertiaryOpacity
                                    ))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                ASCIIDivider()
                    .padding(.horizontal)

                settingRow(title: "DISPLAY") {
                    HStack(spacing: 16) {
                        ForEach(displayModes, id: \.self) { mode in
                            Button {
                                displayMode = mode
                            } label: {
                                Text(mode.uppercased())
                                    .font(AppTheme.font(size: 16))
                                    .foregroundStyle(.primary.opacity(
                                        displayMode == mode
                                            ? AppTheme.headlineOpacity
                                            : AppTheme.tertiaryOpacity
                                    ))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }

                ASCIIDivider()
                    .padding(.horizontal)

                settingRow(title: "DIFFICULTY") {
                    VStack(spacing: 8) {
                        HStack(spacing: 16) {
                            ForEach(Difficulty.allCases, id: \.self) { level in
                                Button {
                                    difficulty = level.rawValue
                                } label: {
                                    Text(level.displayName)
                                        .font(AppTheme.font(size: 16))
                                        .foregroundStyle(.primary.opacity(
                                            difficulty == level.rawValue
                                                ? AppTheme.headlineOpacity
                                                : AppTheme.tertiaryOpacity
                                        ))
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        Text("FILTERS THE WORD POOL")
                            .font(AppTheme.font(size: 11))
                            .tertiaryStyle()
                    }
                }

                ASCIIDivider()
                    .padding(.horizontal)

                settingRow(title: "WORD LENGTH") {
                    HStack(spacing: 16) {
                        ForEach(wordLengths, id: \.self) { length in
                            Button {
                                wordLength = length
                            } label: {
                                Text(length.uppercased())
                                    .font(AppTheme.font(size: 16))
                                    .foregroundStyle(.primary.opacity(
                                        wordLength == length
                                            ? AppTheme.headlineOpacity
                                            : AppTheme.tertiaryOpacity
                                    ))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }

            Spacer()

            Button {
                withoutNavAnimation { showStats = true }
            } label: {
                Text("Statistics")
                    .asciiBracket(.secondary, fontSize: 16)
            }
            .padding(.bottom, 8)
        }
        .padding()
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $showStats) {
            StatsScreen(scoreManager: scoreManager)
        }
    }

    private func settingRow<Content: View>(title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(spacing: 12) {
            Text(title)
                .font(AppTheme.font(size: 14))
                .secondaryStyle()
            content()
        }
    }
}
