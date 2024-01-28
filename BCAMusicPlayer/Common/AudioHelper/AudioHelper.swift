//
//  AudioHelper.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import AVFoundation

final class AudioHelper {
    static let shared = AudioHelper()
    private init() { }
    
    var player: AVPlayer?
    
    func playAudio(of link: URL) {
        let playerItem = AVPlayerItem(url: link)
        player = AVPlayer(playerItem: playerItem)
        play()
    }
    
    func play() {
        player?.play()
    }
    
    func pause() {
        player?.pause()
    }
}
