import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @AppStorage("hangman_isDarkMode") private var isDarkMode = true
    @State private var showModeSelection = false
    @State private var showStats = false

    var body: some View {
        VStack(spacing: 32) {
            themeToggle
            Spacer()
            titleSection
            Spacer()
            playButton
            Spacer()
            navLinks
        }
        .padding()
        .navigationDestination(isPresented: $showModeSelection) {
            ModeSelectionScreen(
                scoreManager: scoreManager,
                wordService: wordService,
                soundManager: soundManager
            )
        }
        .navigationDestination(isPresented: $showStats) {
            StatsScreen(scoreManager: scoreManager)
        }
    }

    private var titleSection: some View {
        ASCIITitleBox("HANGMAN (THE)")
    }

    private var playButton: some View {
        Button {
            withoutNavAnimation { showModeSelection = true }
        } label: {
            Text("PLAY")
                .asciiBracket(.primary, fontSize: 24)
        }
    }

    private var themeToggle: some View {
        HStack {
            Spacer()
            Button {
                soundManager.isMuted.toggle()
            } label: {
                Text(soundManager.isMuted ? "SFX OFF" : "SFX ON")
                    .font(AppTheme.font(size: 14))
                    .foregroundStyle(.primary.opacity(AppTheme.secondaryOpacity))
            }
            .buttonStyle(.plain)

            Button {
                isDarkMode.toggle()
            } label: {
                Text(isDarkMode ? "NIGHT" : "DAY")
                    .font(AppTheme.font(size: 14))
                    .foregroundStyle(.primary.opacity(AppTheme.secondaryOpacity))
            }
            .buttonStyle(.plain)
        }
    }

    private var navLinks: some View {
        Button {
            withoutNavAnimation { showStats = true }
        } label: {
            Text("Statistics")
                .asciiBracket(.secondary, fontSize: 16)
        }
        .padding(.bottom, 8)
    }
}
