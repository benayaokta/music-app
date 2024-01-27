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
import NVActivityIndicatorView

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
    
    private let loadingIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .black, padding: CGFloat(80))
    
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
            loadingIndicator
        }
    }
    
    private func setupConstraint() {
        tableView.fillContainer()
        loadingIndicator.centerHorizontally().centerVertically().width(40).heightEqualsWidth()
    }
    
    private func setupStyle() {
        self.title = "Search Music"
        tableView.backgroundColor = .white
    }
    
    private func setupActions() {
        
    }
    
    private func setupObservables() {
        self.localSearchSubject
            .debounce(for: .milliseconds(500),
                      scheduler: RunLoop.main)
            .sink { [weak self] text in
                self?.viewModel.sendSearchResult(text: text)
            }.store(in: &cancellables)
        
        viewModel.shouldReload
            .receive(on: RunLoop.main)
            .sink { [weak self] shouldReload in
            if shouldReload {
                self?.tableView.reloadData()
            }
        }.store(in: &cancellables)
        
        viewModel.viewResultWrapper
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
            guard let self else { return }
            switch value {
            case .idle:
                loadingIndicator.stopAnimating()
            case .loading:
                loadingIndicator.startAnimating()
            case .showAlert(let text):
                DialogHelper().showAlertDialog(on: self, title: "Error", message: text)
            case .hideEmptyView:
                self.tableView.backgroundView = nil
            case .resetState:
                self.setTableViewBG()
            }
        }.store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerCellClass(type: HomeTableViewCell.self)
        setTableViewBG()
    }
    private func setTableViewBG() {
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        localSearchSubject.send("")
    }
}

extension HomeViewController: UISearchControllerDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        localSearchSubject.send(searchBar.text ?? "")
    }
}
