//
//  HomeTableViewCell.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit
import Stevia

final class HomeTableViewCell: UITableViewCell {
    
    let desc: UILabel = UILabel()

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
            desc
        }
    }
    
    private func setupConstraint() {
        desc.centerHorizontally().centerVertically()
    }
    
    private func setupStyle() {
    }
}
