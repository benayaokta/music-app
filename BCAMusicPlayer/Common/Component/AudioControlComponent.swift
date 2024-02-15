//
//  AudioControlComponent.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 28/01/24.
//

import UIKit
import Stevia
import SDWebImage

final class AudioControlComponent: UIView {
    private let buttonAction: UIButton = UIButton()
    private let trackName: UILabel = UILabel()
    private let trackArtist: UILabel = UILabel()
    private let trackArtwork: UIImageView = UIImageView()
    private let nowPlayingLabel: UILabel = UILabel()
    
    private let backward: UIButton = UIButton()
    private let forward: UIButton = UIButton()
    
    required init?(coder: NSCoder) {
        fatalError("init coder has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        setupHierarchy()
        setupConstraint()
        setupStyle()
    }
    
    private func setupHierarchy() {
        self.subviews {
            nowPlayingLabel
            trackArtwork
            trackName
            trackArtist
            backward
            buttonAction
            forward
        }
    }
    
    private func setupConstraint() {
        nowPlayingLabel.Top == self.safeAreaLayoutGuide.Top + 8
        nowPlayingLabel.Trailing == self.layoutMarginsGuide.Trailing
        nowPlayingLabel.Leading == self.layoutMarginsGuide.Leading
        
        trackArtwork.Top == nowPlayingLabel.Bottom + 8
        trackArtwork.width(80).heightEqualsWidth().Leading == self.layoutMarginsGuide.Leading
        trackArtwork.Bottom == self.safeAreaLayoutGuide.Bottom - 8
        
        trackName.Top == trackArtwork.Top
        trackName.Leading == trackArtwork.Trailing + 8
        
        trackArtist.Leading == trackName.Leading
        trackArtist.Top == trackName.Bottom
        
        trackName.Trailing == self.layoutMarginsGuide.Trailing
        trackArtist.Trailing == trackName.Trailing
        
        backward.width(30).height(20).Leading == trackArtwork.Trailing + 8
        backward.Bottom == trackArtwork.Bottom
        backward.Top >= trackArtist.Bottom + 4

        buttonAction.Leading == backward.Trailing + 8
        buttonAction.Top == backward.Top
        buttonAction.Bottom == backward.Bottom
        buttonAction.Width == backward.Width
        buttonAction.Height == backward.Height
        
        forward.Width == backward.Width
        forward.Height == backward.Height
        forward.Trailing >= self.Trailing - 16
        forward.Top == backward.Top
        forward.Bottom == backward.Bottom
        forward.Leading == buttonAction.Trailing + 16
        
    }
    
    private func setupStyle() {
        self.isHidden = true
        self.backgroundColor = .white
        
        buttonAction.tintColor = .black
        
        nowPlayingLabel.text = "Now Playing"
        
        nowPlayingLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nowPlayingLabel.textColor = .black
        trackName.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        trackName.textColor = .black
        trackArtist.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        trackArtist.textColor = .black
        
        trackName.numberOfLines = 0
        
        backward.setTitle("back", for: .normal)
        backward.setTitleColor(.black, for: .normal)
        forward.setTitle("next", for: .normal)
        forward.setTitleColor(.black, for: .normal)
    }
    
    func togglePlayButton() {
        buttonAction.setImage(UIImage.init(systemName: "play.fill"), for: .normal)
    }
    
    func togglePauseButton() {
        buttonAction.setImage(UIImage.init(systemName: "pause.fill"), for: .normal)
    }
    
    func setButtonAction(handler: @escaping () -> Void) {
        buttonAction.addAction(handler)
    }
    
    func setBackwardAction(handler: @escaping () -> Void) {
        backward.addAction(handler)
    }
    
    func setForwardAction(handler: @escaping () -> Void) {
        forward.addAction(handler)
    }
    
    func showTrack(name: String, artist: String, artwork: String) {
        trackArtwork.sd_imageIndicator = SDWebImageActivityIndicator()
        trackArtwork.sd_setImage(with: URL(string: artwork), placeholderImage: UIImage(named: "photo"), options: [.progressiveLoad])
        
        trackName.text = name
        trackArtist.text = artist
    }
}
