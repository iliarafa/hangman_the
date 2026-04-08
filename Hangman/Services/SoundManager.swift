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
    var isMuted: Bool {
        didSet {
            UserDefaults.standard.set(isMuted, forKey: "hangman_soundMuted")
            if isMuted {
                backgroundPlayer?.pause()
            } else if let track = currentTrack {
                if backgroundPlayer != nil {
                    backgroundPlayer?.play()
                } else {
                    let saved = track
                    currentTrack = nil
                    playBackgroundMusic(saved)
                }
            }
        }
    }

    private var players: [SoundEffect: AVAudioPlayer] = [:]
    private var backgroundPlayer: AVAudioPlayer?
    private var currentTrack: String?

    init() {
        self.isMuted = UserDefaults.standard.bool(forKey: "hangman_soundMuted")
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
        guard !isMuted else { return }
        if let player = players[effect] {
            player.currentTime = 0
            player.play()
        } else {
            AudioServicesPlaySystemSound(effect.systemSoundID)
        }
    }

    func playBackgroundMusic(_ name: String) {
        guard currentTrack != name else { return }
        backgroundPlayer?.stop()
        currentTrack = name
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: name, withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = -1
            player.volume = 0.3
            player.prepareToPlay()
            player.play()
            backgroundPlayer = player
        } catch {
            // Music file not available
        }
    }

    func playWinMusic() {
        backgroundPlayer?.stop()
        currentTrack = nil
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: "winmusic", withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 0.3
            player.prepareToPlay()
            player.play()
            backgroundPlayer = player
        } catch {
            // Win music not available
        }
    }

    func playLossMusic() {
        backgroundPlayer?.stop()
        currentTrack = nil
        guard !isMuted else { return }
        guard let url = Bundle.main.url(forResource: "lossmusic", withExtension: "mp3") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            player.numberOfLoops = 0
            player.volume = 0.3
            player.prepareToPlay()
            player.play()
            backgroundPlayer = player
        } catch {
            // Loss music not available
        }
    }

    func stopBackgroundMusic() {
        backgroundPlayer?.stop()
        backgroundPlayer = nil
        currentTrack = nil
    }
}
