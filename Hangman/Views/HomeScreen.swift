import SwiftUI

struct HomeScreen: View {
    let scoreManager: ScoreManager
    let wordService: WordService
    let soundManager: SoundManager

    @AppStorage("hangman_isDarkMode") private var isDarkMode = true
    @State private var showModeSelection = false

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
    }

    private var titleSection: some View {
        ASCIITitleBox("HANGMAN (THE)", charWidth: 26)
    }

    private var playButton: some View {
        Button {
            UIView.setAnimationsEnabled(false)
            showModeSelection = true
            DispatchQueue.main.async {
                UIView.setAnimationsEnabled(true)
            }
        } label: {
            Text("PLAY")
                .asciiBracket(.primary, fontSize: 24)
        }
    }

    private var themeToggle: some View {
        HStack {
            Spacer()
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
        NavigationLink {
            StatsScreen(scoreManager: scoreManager)
        } label: {
            Text("Statistics")
                .asciiBracket(.secondary, fontSize: 16)
        }
        .padding(.bottom, 8)
    }
}
