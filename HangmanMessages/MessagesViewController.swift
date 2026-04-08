import UIKit
import Messages
import SwiftUI

class MessagesViewController: MSMessagesAppViewController {

    private let soundManager = SoundManager()

    // MARK: - Conversation Handling

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        presentContent(for: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        presentContent(for: conversation)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        guard let conversation = activeConversation else { return }
        presentContent(for: conversation)
    }

    // MARK: - Content Presentation

    private func presentContent(for conversation: MSConversation) {
        // Remove any existing child view controllers
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        if presentationStyle == .compact {
            showCompactView()
            return
        }

        // Check if there's an active message with game state
        if let message = conversation.selectedMessage,
           let url = message.url,
           let gameState = MessageGameState.decode(from: url) {
            switch gameState.phase {
            case .wordSet:
                // We received a word to guess — check if we sent it
                if message.senderParticipantIdentifier == conversation.localParticipantIdentifier {
                    // We sent this message — show waiting view
                    showWaitingView(word: gameState.targetWord)
                } else {
                    // We received this — play the game
                    showGameView(gameState: gameState, conversation: conversation)
                }
            case .completed:
                // Show the result and allow starting a new game
                showResultView(gameState: gameState, conversation: conversation)
            }
        } else {
            // No active game — show set word view
            showSetWordView(conversation: conversation)
        }
    }

    // MARK: - View Presentation

    private func showCompactView() {
        guard let conversation = activeConversation else { return }
        // Show the same content in compact — the keyboard will expand when needed
        if let message = conversation.selectedMessage,
           let url = message.url,
           let gameState = MessageGameState.decode(from: url) {
            switch gameState.phase {
            case .wordSet:
                if message.senderParticipantIdentifier == conversation.localParticipantIdentifier {
                    showWaitingView(word: gameState.targetWord)
                } else {
                    showGameView(gameState: gameState, conversation: conversation)
                }
            case .completed:
                showResultView(gameState: gameState, conversation: conversation)
            }
        } else {
            showSetWordView(conversation: conversation)
        }
    }

    private func showSetWordView(conversation: MSConversation) {
        let view = MessageSetWordView { [weak self] word in
            self?.sendWord(word, conversation: conversation)
        }

        embed(UIHostingController(rootView: view))
    }

    private func showGameView(gameState: MessageGameState, conversation: MSConversation) {
        let view = MessageGameView(
            targetWord: gameState.targetWord,
            senderName: gameState.senderName,
            soundManager: soundManager
        ) { [weak self] completedGame in
            self?.sendResult(
                originalState: gameState,
                completedGame: completedGame,
                conversation: conversation
            )
        }

        embed(UIHostingController(rootView: view))
    }

    private func showResultView(gameState: MessageGameState, conversation: MSConversation) {
        let view = VStack(spacing: 24) {
            MessageResultView(gameState: gameState)
            Button {
                self.showSetWordView(conversation: conversation)
            } label: {
                Text("NEW GAME")
                    .asciiBracket(.primary, fontSize: 20)
            }
        }

        embed(UIHostingController(rootView: view))
    }

    private func showWaitingView(word: String) {
        let view = VStack(spacing: 16) {
            Spacer()
            ASCIITitleBox("WAITING...")
            Text("Your word: \(word.uppercased())")
                .font(AppTheme.font(size: 18))
                .bodyStyle()
            Text("Waiting for opponent to guess")
                .font(AppTheme.font(size: 14))
                .secondaryStyle()
            Spacer()
        }
        .padding()

        embed(UIHostingController(rootView: view))
    }

    // MARK: - Message Composition

    private func sendWord(_ word: String, conversation: MSConversation) {
        let localName = conversation.localParticipantIdentifier.uuidString
        let displayName = String(localName.prefix(8))
        let gameState = MessageGameState(targetWord: word.uppercased(), senderName: displayName)

        guard let url = gameState.encodeToURL() else { return }

        let message = MSMessage(session: conversation.selectedMessage?.session ?? MSSession())
        message.url = url

        let layout = MSMessageTemplateLayout()
        layout.caption = "Guess my word!"
        layout.subcaption = "\(word.count) letters"
        message.layout = layout

        conversation.insert(message) { [weak self] error in
            if error == nil {
                self?.dismiss()
            }
        }
    }

    private func sendResult(originalState: MessageGameState, completedGame: GameState, conversation: MSConversation) {
        let resultState = MessageGameState(
            targetWord: originalState.targetWord,
            senderName: originalState.senderName,
            guessedLetters: completedGame.guessedLetters,
            wrongWordGuesses: completedGame.wrongWordGuesses,
            won: completedGame.status == .won
        )

        guard let url = resultState.encodeToURL() else { return }

        let message = MSMessage(session: conversation.selectedMessage?.session ?? MSSession())
        message.url = url

        let layout = MSMessageTemplateLayout()
        if completedGame.status == .won {
            layout.caption = "I guessed your word!"
            layout.subcaption = originalState.targetWord.uppercased()
        } else {
            layout.caption = "I couldn't guess it..."
            layout.subcaption = originalState.targetWord.uppercased()
        }
        message.layout = layout

        conversation.insert(message) { [weak self] error in
            if error == nil {
                self?.dismiss()
            }
        }
    }

    // MARK: - Helpers

    private func embed(_ controller: UIViewController) {
        addChild(controller)
        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(controller.view)
        controller.didMove(toParent: self)
    }
}
