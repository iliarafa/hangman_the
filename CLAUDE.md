# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a native iOS app (Swift/SwiftUI) with no external dependencies. Build exclusively through Xcode:

```bash
# Open project
open Hangman.xcodeproj

# Build from command line
xcodebuild -project Hangman.xcodeproj -scheme Hangman -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run tests (43 tests across 3 suites)
xcodebuild test -project Hangman.xcodeproj -scheme Hangman -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```

There is no SPM Package.swift, no CocoaPods, and no linter configuration.

## Architecture

MVVM with SwiftUI's `@Observable` macro (iOS 17+). No third-party dependencies — only SwiftUI, AVFoundation, and Foundation.

**Entry point**: `HangmanApp.swift` creates the root `NavigationStack` and injects three shared dependencies: `ScoreManager`, `SoundManager`, and `WordService`.

**Navigation flow**: HomeScreen → ModeSelectionScreen → GameScreen (Arcade) or VSModeView (VS Mode) → StatsScreen → HistoryScreen

### Layers

- **Models/** — Pure data: `GameState` (game logic, win/loss, hints), `ScoreData` (statistics), `VSSession` (two-player round tracking with configurable round limits), `GameRecord` (per-game history entry), `Difficulty` enum (easy/normal/hard)
- **ViewModels/** — `@Observable` classes: `GameViewModel` (arcade mode with difficulty and hints), `VSGameViewModel` (VS mode). These orchestrate services and expose state to views.
- **Views/** — SwiftUI screens and `Components/` (reusable: `KeyboardView`, `WordDisplay`, `ASCIIHangman`, `ConfettiView`, `LetterButton`, `PixelFloodView`, `SolveWordView`, `PauseOverlayView`)
- **Services/** — `WordService` (Swift actor, fetches from `random-word-api.vercel.app` with fallback to bundled `fallback_words.txt` and offline detection), `SoundManager` (AVAudioPlayer with mute toggle), `ScoreManager` (UserDefaults persistence with game history), `WordValidator` (UITextChecker dictionary validation)

### Key Patterns

- `WordService` is a Swift `actor` using async/await. It fetches random words of length 4–10 and falls back to the bundled word list on network failure. `fetchWordResult()` returns a `WordResult` with offline status.
- Score persistence uses UserDefaults with keys prefixed `hangman_` (`wins`, `losses`, `currentStreak`, `bestStreak`, `gameHistory`, `soundMuted`).
- Sound effects fall back to system sounds (AudioToolbox) if MP3 files aren't bundled. Mute state persisted via `@AppStorage`.
- The hangman figure is rendered as ASCII art text with 7 progressive stages, scaled proportionally for different difficulty levels.
- Design uses VT323 pixel font (`.custom("VT323-Regular", size:, relativeTo: .body)`) with grayscale opacity hierarchy for visual weight. Supports Dynamic Type.
- Navigation animations are suppressed via `withoutNavAnimation()` helper in `AppTheme.swift` (wraps `UIView.setAnimationsEnabled`).
- `PixelFloodView` and `ConfettiView` respect `accessibilityReduceMotion`.
- VoiceOver labels are provided on all interactive elements and game state displays.

## Testing

Test target: `HangmanTests/` (Swift Testing framework, not XCTest). Shared scheme at `Hangman.xcodeproj/xcshareddata/xcschemes/Hangman.xcscheme`.

- `GameStateTests` — guessing logic, win/loss conditions, hints, difficulty
- `VSSessionTests` — scoring, setter rotation, round limits, winner detection
- `ScoreManagerTests` — streaks, reset, persistence (uses `@Suite(.serialized)` due to shared UserDefaults)
