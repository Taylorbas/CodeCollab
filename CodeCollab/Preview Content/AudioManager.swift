//
//  AudioManager.swift
//  CodeCollab
//
//  Created by Bassil Taylor on 2/25/25.
//

import AVFoundation
class AudioManager: ObservableObject {
    static let shared = AudioManager()
    private var player: AVAudioPlayer?
     init() {}
    func playBackgroundMusic() {
        guard let url = Bundle.main.url(forResource: "Aylex - Meditation (freetouse.com)", withExtension: "mp3") else {
            print("Error: MP3 file not found")
            return
        }
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.numberOfLoops = -1
            player?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    func stopBackgroundMusic() {
        player?.stop()
    }
}
