//
//  AudioHelper.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import AVFoundation
import Combine

final class AudioHelper {
    static let shared = AudioHelper()
    
    @Published var isPlaying: Bool = false
    
    
    private init() {
        NotificationCenter.default.addObserver(
                self,
                selector: #selector(playComplete),
                name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                object: nil
            )
    }
    
    var player: AVPlayer?
    
    func playAudio(of link: URL) {
        if isPlaying {
            pause()
        }
        
        let playerItem = AVPlayerItem(url: link)
        player = AVPlayer(playerItem: playerItem)
    }
    
    func play() {
        player?.play()
        isPlaying = true
    }
    
    func pause() {
        if isPlaying {
            player?.pause()
            isPlaying = false
        }
    }
    
    @objc private func playComplete() {
        pause()
        player?.seek(to: CMTime.zero)
    }
    
}
