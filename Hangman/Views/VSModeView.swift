import SwiftUI

enum VSRoute: Hashable {
    case wordEntry
    case countdown(word: String)
    case game
    case result
    case finalResult
}

struct VSModeView: View {
    let soundManager: SoundManager

    @Environment(\.dismiss) private var dismiss
    @State private var path = NavigationPath()
    @State private var viewModel: VSGameViewModel?
    @State private var startTrigger = 0

    var body: some View {
        NavigationStack(path: $path) {
            VSNameEntryScreen(soundManager: soundManager) { vm in
                viewModel = vm
                startTrigger += 1
            }
            .navigationDestination(for: VSRoute.self) { route in
                if let viewModel {
                    destinationView(for: route, viewModel: viewModel)
                }
            }
        }
        .tint(.primary)
        .onAppear { soundManager.playBackgroundMusic("gamemusic") }
        .onDisappear { soundManager.playBackgroundMusic("mainmusic") }
        .onChange(of: startTrigger) {
            withoutNavAnimation { path.append(VSRoute.wordEntry) }
        }
        .onReceive(NotificationCenter.default.publisher(for: .navigateToHome)) { _ in
            withoutNavAnimation(restoreDelay: 0.05) {
                path = NavigationPath()
                dismiss()
            }
        }
    }

    @ViewBuilder
    private func destinationView(for route: VSRoute, viewModel: VSGameViewModel) -> some View {
        switch route {
        case .wordEntry:
            VSWordEntryScreen(viewModel: viewModel, onReady: { word in
                withoutNavAnimation { path.append(VSRoute.countdown(word: word)) }
            }, onBack: {
                withoutNavAnimation {
                    if path.isEmpty {
                        dismiss()
                    } else {
                        path.removeLast()
                    }
                }
            })
        case .countdown(let word):
            VSCountdownScreen(viewModel: viewModel, word: word) {
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    path.append(VSRoute.game)
                }
            }
        case .game:
            VSGameScreen(viewModel: viewModel) {
                withoutNavAnimation { path.append(VSRoute.result) }
            }
        case .result:
            VSRoundResultScreen(
                viewModel: viewModel,
                onNextRound: {
                    UIView.setAnimationsEnabled(false)
                    path = NavigationPath()
                    DispatchQueue.main.async {
                        path.append(VSRoute.wordEntry)
                        DispatchQueue.main.async { UIView.setAnimationsEnabled(true) }
                    }
                },
                onEndGame: {
                    UIView.setAnimationsEnabled(false)
                    path = NavigationPath()
                    DispatchQueue.main.async {
                        path.append(VSRoute.finalResult)
                        DispatchQueue.main.async { UIView.setAnimationsEnabled(true) }
                    }
                }
            )
        case .finalResult:
            VSFinalScreen(viewModel: viewModel) {
                withoutNavAnimation { dismiss() }
            }
        }
    }
}
