import SwiftUI

struct OnboardingView: View {
    let onComplete: () -> Void

    @State private var currentPage = 0

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                page1.tag(0)
                page2.tag(1)
                page3.tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
        }
    }

    // MARK: - Page 1: The Game

    private var page1: some View {
        VStack(spacing: 32) {
            Spacer()

            ASCIIHangman(wrongGuessCount: 6)

            Text("GUESS THE WORD")
                .font(AppTheme.font(size: 24))
                .headlineStyle()

            Text("Letter by letter.\nDon't get hanged.")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
                .multilineTextAlignment(.center)

            Spacer()
        }
        .padding()
    }

    // MARK: - Page 2: Game Modes

    private var page2: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 24) {
                Text("[ ARCADE ]")
                    .font(AppTheme.font(size: 22))
                    .headlineStyle()
                Text("Play solo against\nrandom words")
                    .font(AppTheme.font(size: 16))
                    .secondaryStyle()
                    .multilineTextAlignment(.center)
            }

            ASCIIDivider()
                .padding(.horizontal, 48)

            VStack(spacing: 24) {
                Text("[ VS MODE ]")
                    .font(AppTheme.font(size: 22))
                    .headlineStyle()
                Text("Pass & play with\na friend")
                    .font(AppTheme.font(size: 16))
                    .secondaryStyle()
                    .multilineTextAlignment(.center)
            }

            Spacer()
        }
        .padding()
    }

    // MARK: - Page 3: Difficulty & Start

    private var page3: some View {
        VStack(spacing: 32) {
            Spacer()

            VStack(spacing: 16) {
                difficultyRow("EASY", guesses: 8)
                difficultyRow("NORMAL", guesses: 6)
                difficultyRow("HARD", guesses: 4)
            }

            Text("Change anytime\nin Settings")
                .font(AppTheme.font(size: 14))
                .secondaryStyle()
                .multilineTextAlignment(.center)

            Spacer()

            Button {
                onComplete()
            } label: {
                Text("LET'S PLAY")
                    .asciiBracket(.primary, fontSize: 24)
            }

            Spacer()
        }
        .padding()
    }

    private func difficultyRow(_ name: String, guesses: Int) -> some View {
        HStack {
            Text(name)
                .font(AppTheme.font(size: 18))
                .headlineStyle()
                .frame(width: 100, alignment: .leading)
            Text("\(guesses) guesses")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
        }
    }
}
