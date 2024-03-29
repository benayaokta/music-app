//
//  HomeTableViewCell.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit
import Stevia

final class HomeTableViewCell: UITableViewCell {
    
    let trackArtwork: UIImageView = UIImageView()
    let trackName: UILabel = UILabel()
    let artist: UILabel = UILabel()
    let playIcon: UIImageView = UIImageView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init coder is not implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setupStyle()
    }
    
    private func commonInit() {
        setupHierarchy()
        setupConstraint()
        setupStyle()
    }
    
    private func setupHierarchy() {
        self.subviews {
            trackArtwork
            trackName
            artist
            playIcon
        }
    }
    
    private func setupConstraint() {
        trackArtwork.Leading == self.layoutMarginsGuide.Leading
        trackArtwork.width(60).heightEqualsWidth().Top == self.safeAreaLayoutGuide.Top + 8
        trackArtwork.Bottom == self.safeAreaLayoutGuide.Bottom - 8
        
        trackName.Leading == trackArtwork.Trailing + 16
        artist.Leading == trackName.Leading
        
        trackName.Top == self.safeAreaLayoutGuide.Top + 8
        artist.Bottom == self.safeAreaLayoutGuide.Bottom - 8
        
        artist.Top >= trackName.Bottom + 8
        
        trackName.Trailing == self.playIcon.Leading - 16
        artist.Trailing == trackName.Trailing
        
        playIcon.width(20).heightEqualsWidth().Trailing == self.layoutMarginsGuide.Trailing - 8
        playIcon.Top == self.safeAreaLayoutGuide.Top + 8
        
    }
    
    private func setupStyle() {
        self.backgroundColor = .clear
        trackName.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        trackName.textColor = .black
        artist.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        artist.textColor = .black
        
        playIcon.image = UIImage(systemName: "play.fill")
    }
}
