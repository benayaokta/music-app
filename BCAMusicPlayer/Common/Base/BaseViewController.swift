//
//  BaseViewController.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit

class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
}
