import SwiftUI

struct MessageGameView: View {
    let targetWord: String
    let senderName: String
    let soundManager: SoundManager
    let onComplete: (GameState) -> Void

    @State private var game: GameState
    @State private var showSolve = false

    init(targetWord: String, senderName: String, soundManager: SoundManager, onComplete: @escaping (GameState) -> Void) {
        self.targetWord = targetWord
        self.senderName = senderName
        self.soundManager = soundManager
        self.onComplete = onComplete
        self._game = State(initialValue: GameState(targetWord: targetWord))
    }

    var body: some View {
        VStack(spacing: 12) {
            header
            Spacer()
            ASCIIHangman(wrongGuessCount: game.wrongGuessCount)
            WordDisplay(displayWord: game.displayWord, revealWord: game.status == .lost ? targetWord : nil)
                .padding(.vertical, 8)
            Spacer()

            if game.status == .playing {
                if showSolve {
                    SolveWordView(wordLength: targetWord.count) { word in
                        guessWord(word)
                        showSolve = false
                    }
                } else {
                    Button {
                        showSolve = true
                    } label: {
                        Text("SOLVE")
                            .asciiBracket(.secondary, fontSize: 14)
                    }
                }

                KeyboardView(
                    letterState: { letterState($0) },
                    onTap: { guess(letter: $0) }
                )
            } else {
                gameResult
            }
        }
        .padding()
    }

    private var header: some View {
        VStack(spacing: 4) {
            Text("\(senderName)'s word")
                .font(AppTheme.font(size: 16))
                .secondaryStyle()
        }
    }

    private var gameResult: some View {
        VStack(spacing: 16) {
            if game.status == .won {
                Text("YOU WON")
                    .font(AppTheme.font(size: 36))
                    .headlineStyle()
            } else {
                Text("YOU LOST")
                    .font(AppTheme.font(size: 36))
                    .headlineStyle()
            }

            Button {
                onComplete(game)
            } label: {
                Text("SEND RESULT")
                    .asciiBracket(.primary, fontSize: 20)
            }
        }
    }

    // MARK: - Game Logic

    private func guess(letter: Character) {
        guard game.status == .playing else { return }
        guard !game.guessedLetters.contains(letter) else { return }

        game.guessedLetters.insert(letter)

        if game.targetWord.uppercased().contains(letter) {
            soundManager.play(.correct)
            if game.isWon { game.status = .won; soundManager.play(.win) }
        } else {
            soundManager.play(.wrong)
            if game.isLost { game.status = .lost; soundManager.play(.lose) }
        }
    }

    private func guessWord(_ word: String) {
        guard game.status == .playing else { return }
        let previousCount = game.wrongGuessCount
        let isCorrect = game.guessWord(word)
        if isCorrect {
            game.status = .won
            soundManager.play(.win)
        } else if game.wrongGuessCount > previousCount {
            soundManager.play(.wrong)
            if game.isLost { game.status = .lost; soundManager.play(.lose) }
        }
    }

    private func letterState(_ letter: Character) -> LetterState {
        guard game.guessedLetters.contains(letter) else { return .unused }
        return game.targetWord.uppercased().contains(letter) ? .correct : .wrong
    }
}
