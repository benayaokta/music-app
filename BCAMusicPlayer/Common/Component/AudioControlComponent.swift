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
            buttonAction
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
        trackArtist.Bottom == trackArtwork.Bottom
        trackArtist.Top >= trackName.Bottom + 8
        
        trackName.Trailing == buttonAction.Leading - 16
        trackArtist.Trailing == trackName.Trailing

        buttonAction.width(50).heightEqualsWidth().centerVertically().Trailing == self.layoutMarginsGuide.Trailing - 16
        
    }
    
    private func setupStyle() {
        self.isHidden = true
        self.backgroundColor = .white
        buttonAction.setTitleColor(.black, for: .normal)
        
        nowPlayingLabel.text = "Now Playing"
        
        nowPlayingLabel.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        nowPlayingLabel.textColor = .black
        trackName.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        trackName.textColor = .black
        trackArtist.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        trackArtist.textColor = .black
        
        trackName.numberOfLines = 0
    }
    
    func setTitle(text: String) {
        buttonAction.setTitle(text, for: .normal)
    }
    
    func setButtonAction(handler: @escaping () -> Void) {
        buttonAction.addAction(handler)
    }
    
    func showTrack(name: String, artist: String, artwork: String) {
        trackArtwork.sd_imageIndicator = SDWebImageActivityIndicator()
        trackArtwork.sd_setImage(with: URL(string: artwork), placeholderImage: UIImage(named: "photo"), options: [.progressiveLoad])
        
        trackName.text = name
        trackArtist.text = artist
    }
}
