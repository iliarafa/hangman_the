import SwiftUI

@main
struct HangmanApp: App {
    @AppStorage("hangman_isDarkMode") private var isDarkMode = true
    @State private var scoreManager = ScoreManager()
    @State private var soundManager = SoundManager()
    private let wordService = WordService()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeScreen(
                    scoreManager: scoreManager,
                    wordService: wordService,
                    soundManager: soundManager
                )
            }
            .tint(.primary)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}
