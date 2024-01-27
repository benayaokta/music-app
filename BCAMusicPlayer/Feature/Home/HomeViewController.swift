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
    private let searchController: UISearchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraint()
        setupStyle()
        setupActions()
        setupSearchController()
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
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        
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

extension HomeViewController: UISearchBarDelegate {
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        print("||| search bar cancel did click")
        /*
         reload table
         reset state
         */
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print("||| search text \(searchText)")
    }
}