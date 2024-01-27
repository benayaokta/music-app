//
//  ViewController.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit
import Stevia
import CoreExtension

final class HomeViewController: BaseViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init code")
    }
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    private let tableView: UITableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraint()
        setupStyle()
        setupActions()
        setupTableView()
        setupObservables()
    }
    
    private func setupHierarchy() {
        view.subviews {
            tableView
        }
    }
    
    private func setupConstraint() {
        tableView.fillContainer()
    }
    
    private func setupStyle() {
        self.title = "Search Music"
        tableView.backgroundColor = .white
    }
    
    private func setupActions() {
        
    }
    
    private func setupObservables() {
        
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(type: HomeTableViewCell.self)
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: HomeTableViewCell.self, for: indexPath) as! HomeTableViewCell
        cell.desc.text = "\(indexPath.row + 1)"
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
