import SwiftUI
import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        .portrait
    }
}

@main
struct HangmanApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("hangman_displayMode") private var displayMode: String = "night"
    @AppStorage("hangman_hasLaunchedBefore") private var hasLaunchedBefore = false
    @State private var scoreManager = ScoreManager()
    @State private var soundManager = SoundManager()
    private let wordService = WordService()

    var body: some Scene {
        WindowGroup {
            Group {
                if hasLaunchedBefore {
                    NavigationStack {
                        HomeScreen(
                            scoreManager: scoreManager,
                            wordService: wordService,
                            soundManager: soundManager
                        )
                    }
                    .tint(.primary)
                } else {
                    OnboardingView {
                        hasLaunchedBefore = true
                    }
                    .tint(.mint)
                }
            }
            .preferredColorScheme(
                displayMode == "night" ? .dark : displayMode == "day" ? .light : nil
            )
        }
    }
}
