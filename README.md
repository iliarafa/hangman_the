# HANGMAN (THE)

A minimalist Hangman word game for iPhone. Guess letters to save the figure before it's too late. Features Arcade mode with random words, VS Mode for local two-player challenges, animated hangman figure, sound effects, confetti celebrations, and detailed win/streak/game statistics. Built with SwiftUI.

## Features

- **Arcade Mode** — guess randomly fetched words before running out of attempts
- **VS Mode** — two players take turns setting words for each other
- **Animated Hangman** — body parts drawn progressively with each wrong guess
- **Sound Effects** — audio feedback for correct/wrong guesses and game outcomes
- **Confetti** — celebration animation on wins
- **Statistics** — track wins, losses, streaks, and total games played

## Requirements

- iOS 17.0+
- Xcode 15.0+

## Project Structure

```
Hangman/
├── Models/          # GameState, ScoreData, VSSession
├── ViewModels/      # GameViewModel, VSGameViewModel
├── Views/           # HomeScreen, ModeSelectionScreen, GameScreen, StatsScreen, VS screens
│   └── Components/  # HangmanFigure, KeyboardView, LetterButton, WordDisplay, ConfettiView
├── Services/        # WordService, SoundManager, ScoreManager
└── Resources/       # Fallback word list
```

## Getting Started

1. Clone the repo
2. Open `Hangman.xcodeproj` in Xcode
3. Build and run on a simulator or device
