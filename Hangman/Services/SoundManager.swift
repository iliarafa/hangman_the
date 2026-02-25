import AudioToolbox
import AVFoundation
import SwiftUI

enum SoundEffect: String, CaseIterable {
    case correct
    case wrong
    case win
    case lose

    var systemSoundID: SystemSoundID {
        switch self {
        case .correct: return 1057
        case .wrong: return 1073
        case .win: return 1025
        case .lose: return 1006
        }
    }
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
        if let player = players[effect] {
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(effect.systemSoundID)
        }
    }
}
