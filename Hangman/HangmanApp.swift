import SwiftUI

@main
struct HangmanApp: App {
    @AppStorage("hangman_displayMode") private var displayMode: String = "night"
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
            .preferredColorScheme(
                displayMode == "night" ? .dark : displayMode == "day" ? .light : nil
            )
        }
    }
}
