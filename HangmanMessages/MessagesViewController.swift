import UIKit
import Messages
import SwiftUI

class MessagesViewController: MSMessagesAppViewController {

    private let soundManager = SoundManager()

    // MARK: - Conversation Handling

    override func willBecomeActive(with conversation: MSConversation) {
        super.willBecomeActive(with: conversation)
        print("[Hangman] willBecomeActive — selectedMessage: \(conversation.selectedMessage != nil)")
        presentContent(for: conversation)
    }

    override func didSelect(_ message: MSMessage, conversation: MSConversation) {
        super.didSelect(message, conversation: conversation)
        print("[Hangman] didSelect — message.url: \(message.url?.absoluteString ?? "nil")")
        presentContent(for: conversation)
    }

    override func didTransition(to presentationStyle: MSMessagesAppPresentationStyle) {
        super.didTransition(to: presentationStyle)
        print("[Hangman] didTransition — style: \(presentationStyle.rawValue)")
        guard let conversation = activeConversation else { return }
        presentContent(for: conversation)
    }

    // MARK: - Content Presentation

    private func presentContent(for conversation: MSConversation) {
        // All our views need full extension height — always request expanded
        if presentationStyle != .expanded {
            requestPresentationStyle(.expanded)
        }

        // Remove any existing child view controllers
        for child in children {
            child.willMove(toParent: nil)
            child.view.removeFromSuperview()
            child.removeFromParent()
        }

        // Build diagnostic text visible on-screen
        var diag = "style=\(presentationStyle.rawValue)\n"
        diag += "selMsg=\(conversation.selectedMessage != nil)\n"
        diag += "url=\(conversation.selectedMessage?.url?.absoluteString.prefix(40) ?? "nil")\n"

        // Check if there's an active message with game state
        if let message = conversation.selectedMessage,
           let url = message.url {
            diag += "hasURL=yes\n"
            if let gameState = MessageGameState.decode(from: url) {
                diag += "decoded=yes phase=\(gameState.phase.rawValue)\n"
                diag += "word=\(gameState.targetWord)\n"
                diag += "senderID=\(gameState.senderIdentifier?.prefix(8) ?? "nil")\n"
                diag += "localID=\(conversation.localParticipantIdentifier.uuidString.prefix(8))\n"

                switch gameState.phase {
                case .wordSet:
                    let localID = conversation.localParticipantIdentifier.uuidString
                    let weAreSender: Bool
                    if let senderID = gameState.senderIdentifier {
                        weAreSender = (senderID == localID)
                    } else {
                        weAreSender = (message.senderParticipantIdentifier == conversation.localParticipantIdentifier)
                    }
                    diag += "weAreSender=\(weAreSender)\n"
                    diag += "-> would show: \(weAreSender ? "WAITING" : "GAME")"
                case .completed:
                    diag += "-> would show: RESULT"
                }
            } else {
                diag += "decoded=NO (decoding failed)"
            }
        } else {
            diag += "-> would show: SET WORD"
        }

        showDiagnosticView(text: diag, conversation: conversation)
    }

    private func showDiagnosticView(text: String, conversation: MSConversation) {
        let view = VStack(alignment: .leading, spacing: 12) {
            Text("DIAGNOSTIC")
                .font(AppTheme.font(size: 18))
                .headlineStyle()
            Text(text)
                .font(AppTheme.font(size: 14))
                .bodyStyle()
                .textSelection(.enabled)
            Spacer()
            Button {
                self.showSetWordView(conversation: conversation)
            } label: {
                Text("SET WORD")
                    .asciiBracket(.primary, fontSize: 20)
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)

        embed(UIHostingController(rootView: view))
    }

    // MARK: - View Presentation

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
        let localID = conversation.localParticipantIdentifier.uuidString
        let displayName = String(localID.prefix(8))
        let gameState = MessageGameState(targetWord: word.uppercased(), senderName: displayName, senderIdentifier: localID)

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
            senderIdentifier: originalState.senderIdentifier,
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
        controller.view.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(controller.view)
        NSLayoutConstraint.activate([
            controller.view.topAnchor.constraint(equalTo: view.topAnchor),
            controller.view.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controller.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            controller.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
        controller.didMove(toParent: self)
    }
}
