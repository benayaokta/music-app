//
//  ViewController.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit

final class HomeViewController: BaseViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init code")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraint()
        setupStyle()
        setupActions()
        setupObservables()
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupConstraint() {
        
    }
    
    private func setupStyle() {
        
    }
    
    private func setupActions() {
        
    }
    
    private func setupObservables() {
        
    }

}

