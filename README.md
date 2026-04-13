# HANGMAN (THE)

A retro-styled Hangman word game for iPhone and iPad. Guess letters to save the figure before it's too late. Features Arcade mode with difficulty levels and hints, VS Mode for local two-player challenges with configurable rounds, iMessage extension for turn-based play, animated ASCII hangman figure, sound effects, confetti celebrations, a built-in dictionary with word definitions, and detailed statistics. Built with SwiftUI using the VT323 pixel font.

## Features

- **Arcade Mode** — guess randomly fetched words before running out of attempts
- **Difficulty Levels** — Easy, Normal, or Hard — words are scored by length, rare letters, and vowel ratio to match your chosen difficulty
- **Hints** — reveal a letter when you're stuck (available while 2+ letters remain)
- **VS Mode** — two players take turns setting words for each other
- **iMessage Extension** — challenge friends to hangman directly in Messages
- **Round Limits** — configure VS matches as best-of-3, 5, 7, or unlimited
- **Animated Hangman** — ASCII body parts drawn progressively with each wrong guess
- **Sound Effects** — audio feedback for correct/wrong guesses and game outcomes, with mute toggle
- **Confetti** — celebration animation on wins
- **Statistics** — track wins, losses, streaks, and win rate
- **Dictionary** — review your last 50 games with words, definitions, outcomes, and dates
- **Offline Support** — falls back to bundled word list when offline, with indicator
- **Accessibility** — VoiceOver labels, Dynamic Type support, reduced motion support
- **Settings** — sound, display mode (day/night/system), and difficulty all in one place
- **Dark/Light Mode** — toggle between day, night, and system themes

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Project Structure

```
Hangman/
├── Models/          # GameState, ScoreData, VSSession, GameRecord, Difficulty
├── ViewModels/      # GameViewModel, VSGameViewModel
├── Views/           # HomeScreen, ModeSelectionScreen, GameScreen, StatsScreen,
│   │                  HistoryScreen (Dictionary), VS screens (6 screens)
│   └── Components/  # ASCIIHangman, KeyboardView, LetterButton, WordDisplay,
│                      ConfettiView, PixelFloodView, SolveWordView, PauseOverlayView,
│                      AppTheme, ASCIIStyles
├── Services/        # WordService, SoundManager, ScoreManager, WordValidator
└── Resources/       # Fallback word list, VT323 font
HangmanMessages/     # iMessage extension for turn-based play
HangmanTests/        # 43 unit tests (Swift Testing)
```

## Getting Started

1. Clone the repo
2. Open `Hangman.xcodeproj` in Xcode
3. Build and run on a simulator or device

## Running Tests

```bash
xcodebuild test -project Hangman.xcodeproj -scheme Hangman \
  -sdk iphonesimulator -destination 'platform=iOS Simulator,name=iPhone 16'
```

43 tests across 3 suites: `GameStateTests`, `VSSessionTests`, `ScoreManagerTests`.
