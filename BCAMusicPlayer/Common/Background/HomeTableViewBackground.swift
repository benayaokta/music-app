//
//  HomeTableViewBackground.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit
import Stevia

final class HomeTableViewBackground: UIView {

    private let label = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init coder")
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    private func commonInit() {
        self.subviews {
            label
        }
        setLabelText(text: "Search Here")
        label.centerHorizontally().centerVertically()
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
}
