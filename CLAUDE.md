# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a native iOS app (Swift/SwiftUI) with no external dependencies. Build exclusively through Xcode:

```bash
# Open project
open Hangman.xcodeproj

# Build from command line
xcodebuild -project Hangman.xcodeproj -scheme Hangman -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' build

# No test targets exist yet
```

There is no SPM Package.swift, no CocoaPods, and no linter configuration.

## Architecture

MVVM with SwiftUI's `@Observable` macro (iOS 17+). No third-party dependencies — only SwiftUI, AVFoundation, and Foundation.

**Entry point**: `HangmanApp.swift` creates the root `NavigationStack` and injects three shared dependencies: `ScoreManager`, `SoundManager`, and `WordService`.

**Navigation flow**: HomeScreen → ModeSelectionScreen → GameScreen (Arcade) or VSModeView (VS Mode) → StatsScreen

### Layers

- **Models/** — Pure data: `GameState` (game logic, win/loss conditions), `ScoreData` (statistics), `VSSession` (two-player round tracking)
- **ViewModels/** — `@Observable` classes: `GameViewModel` (arcade mode), `VSGameViewModel` (VS mode). These orchestrate services and expose state to views.
- **Views/** — SwiftUI screens and `Components/` (reusable: `KeyboardView`, `WordDisplay`, `ASCIIHangman`, `ConfettiView`, `LetterButton`)
- **Services/** — `WordService` (Swift actor, fetches from `random-word-api.vercel.app` with fallback to bundled `fallback_words.txt`), `SoundManager` (AVAudioPlayer), `ScoreManager` (`@AppStorage`/UserDefaults persistence with keys prefixed `hangman_`)

### Key Patterns

- `WordService` is a Swift `actor` using async/await. It fetches random words of length 4–10 and falls back to the bundled word list on network failure.
- Score persistence uses `@AppStorage` with keys: `hangman_wins`, `hangman_losses`, `hangman_currentStreak`, `hangman_bestStreak`.
- Sound files are MP3s in `Resources/Sounds/` (correct, wrong, win, lose).
- The hangman figure is rendered as ASCII art text, not drawn graphics.
- Design uses monospaced typography (`.system(design: .monospaced)`) with a minimalist, dark-mode-friendly aesthetic.
