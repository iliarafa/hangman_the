import AVFoundation
import SwiftUI

enum SoundEffect: String, CaseIterable {
    case correct
    case wrong
    case win
    case lose
}

@Observable
final class SoundManager {
    private var players: [SoundEffect: AVAudioPlayer] = [:]

    init() {
        preloadSounds()
    }

    private func preloadSounds() {
        for effect in SoundEffect.allCases {
            guard let url = Bundle.main.url(forResource: effect.rawValue, withExtension: "mp3") else {
                continue
            }
            do {
                let player = try AVAudioPlayer(contentsOf: url)
                player.prepareToPlay()
                players[effect] = player
            } catch {
                // Sound file not available — continue silently
            }
        }
    }

    func play(_ effect: SoundEffect) {
        guard let player = players[effect] else { return }
        player.currentTime = 0
        player.play()
    }
}
