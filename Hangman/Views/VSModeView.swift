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

    var body: some View {
        NavigationStack(path: $path) {
            VSNameEntryScreen(soundManager: soundManager) { vm in
                viewModel = vm
                path.append(VSRoute.wordEntry)
            }
            .navigationDestination(for: VSRoute.self) { route in
                if let viewModel {
                    destinationView(for: route, viewModel: viewModel)
                }
            }
        }
        .tint(.primary)
    }

    @ViewBuilder
    private func destinationView(for route: VSRoute, viewModel: VSGameViewModel) -> some View {
        switch route {
        case .wordEntry:
            VSWordEntryScreen(viewModel: viewModel) { word in
                path.append(VSRoute.countdown(word: word))
            }
        case .countdown(let word):
            VSCountdownScreen(viewModel: viewModel, word: word) {
                path.append(VSRoute.game)
            }
        case .game:
            VSGameScreen(viewModel: viewModel) {
                path.append(VSRoute.result)
            }
        case .result:
            VSRoundResultScreen(
                viewModel: viewModel,
                onNextRound: {
                    path = NavigationPath()
                    DispatchQueue.main.async {
                        path.append(VSRoute.wordEntry)
                    }
                },
                onEndGame: {
                    path = NavigationPath()
                    DispatchQueue.main.async {
                        path.append(VSRoute.finalResult)
                    }
                }
            )
        case .finalResult:
            VSFinalScreen(viewModel: viewModel) {
                dismiss()
            }
        }
    }
}
