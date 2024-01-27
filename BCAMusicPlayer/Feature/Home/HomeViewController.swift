//
//  ViewController.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import UIKit
import Stevia
import CoreExtension
import Combine

final class HomeViewController: BaseViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init code")
    }
    
    init(vm: HomeViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    var viewModel: HomeViewModel!

    private let tableView: UITableView = UITableView()
    private let searchController: UISearchController = UISearchController()
    
    private var localSearchSubject: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private let bgView = HomeTableViewBackground()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupHierarchy()
        setupConstraint()
        setupStyle()
        setupActions()
        setupTableView()
        setupSearchController()
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
        self.localSearchSubject
            .debounce(for: .milliseconds(800), scheduler: RunLoop.main)
            .sink { [weak self] text in
                if text != "" {
                    self?.viewModel.sendSearchResult(text: text)
                } else {
                    self?.viewModel.clearData()
                    self?.bgView.setLabelText(text: "Search more music here")
                }
            }.store(in: &cancellables)
        
        viewModel.shouldReload.receive(on: RunLoop.main).sink { [weak self] shouldReload in
            if shouldReload {
                self?.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.viewResultWrapper.sink { [weak self] value in
            switch value {
            case .idle:
                break
            case .loading:
                break
            case .showSnackbar:
                break
            }
        }.store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(type: HomeTableViewCell.self)
        tableView.backgroundView = bgView
    }
    
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchBar.delegate = self
        searchController.searchBar.isHidden = false
        searchController.isActive = true
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = true
        definesPresentationContext = true
    }

}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.allArtist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueCell(withType: HomeTableViewCell.self, for: indexPath) as! HomeTableViewCell
        cell.desc.text = viewModel.allArtist[indexPath.row]
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}

extension HomeViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text: String = searchBar.text ?? ""
        localSearchSubject.send(text)
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        localSearchSubject.send(searchBar.text ?? "")
    }
}
