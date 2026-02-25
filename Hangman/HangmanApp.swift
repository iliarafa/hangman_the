import SwiftUI

@main
struct HangmanApp: App {
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
            .tint(.purple)
        }
    }
}
