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
import SDWebImage

final class HomeViewController: BaseViewController {
    
    required init?(coder: NSCoder) {
        fatalError("init code")
    }
    
    init(vm: HomeViewModel) {
        self.viewModel = vm
        super.init(nibName: nil, bundle: nil)
    }
    
    var viewModel: HomeViewModel
    
    @Published private var shouldShowAudioControl: Bool = false
    @Published private var nowPlaying: ResultEntity?

    private let tableView: UITableView = UITableView()
    private let searchController: UISearchController = UISearchController()
    
    private var localSearchSubject: PassthroughSubject<String, Never> = PassthroughSubject<String, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    private let bgView = HomeTableViewBackground()
    
    private let loadingIndicator: NVActivityIndicatorView = NVActivityIndicatorView(frame: .zero, type: .circleStrokeSpin, color: .black, padding: CGFloat(80))
    
    private let audioPlayingView: AudioControlComponent = AudioControlComponent()
    private var isPlayingFlag: Bool = false
    
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
            audioPlayingView
        }
    }
    
    private func setupConstraint() {
        tableView.fillHorizontally().Top == self.view.safeAreaLayoutGuide.Top
        tableView.Bottom == self.view.safeAreaLayoutGuide.Bottom
        loadingIndicator.centerHorizontally().centerVertically().width(40).heightEqualsWidth()
        audioPlayingView.fillHorizontally().centerHorizontally().Bottom == self.view.safeAreaLayoutGuide.Bottom
    }
    
    private func setupStyle() {
        self.title = "Search Artists"
        tableView.backgroundColor = .white
        audioPlayingView.isHidden = true
    }
    
    private func setupActions() {
        audioPlayingView.setButtonAction(handler: { [weak self] in
            /// ga perlu ke vm karena ada ini urusan si audio singleton
            guard let self else { return }
            if self.isPlayingFlag {
                AudioHelper.shared.pause()
            } else {
                AudioHelper.shared.play()
            }
        })
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
        
        AudioHelper.shared.$isPlaying
            .sink { [weak self] isPlaying in
                guard let self else { return }
                self.isPlayingFlag = isPlaying
                if isPlaying {
                    self.audioPlayingView.togglePauseButton()
                } else {
                    self.audioPlayingView.togglePlayButton()
                }
            }.store(in: &cancellables)
        
        self.$shouldShowAudioControl
            .receive(on: RunLoop.main)
            .sink { [weak self] shouldShowControl in
                guard let self else { return }
                if shouldShowControl {
                    self.audioPlayingView.isHidden = false
                }
            }.store(in: &cancellables)
        
        self.$nowPlaying.sink { [weak self] data in
            guard let self else { return }
            self.audioPlayingView.showTrack(name: data?.songs ?? "",
                                            artist: data?.name ?? "",
                                            artwork: data?.artworlURLString ?? "")
        }.store(in: &cancellables)
    }
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
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
        searchController.searchBar.barStyle = .default
        searchController.searchBar.tintColor = .black
        searchController.searchBar.searchTextField.tintColor = .black
        searchController.searchBar.searchTextField.textColor = .black
        searchController.searchBar.searchTextField.backgroundColor = .white
            
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
        let data = viewModel.allArtist.results[indexPath.row]
        cell.artist.text = data.name
        cell.trackName.text = data.songs
        cell.trackArtwork.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        cell.trackArtwork.sd_setImage(with: URL(string: data.artworlURLString),
                                      placeholderImage: UIImage(systemName: "photo"),
                                      options: [.progressiveLoad])
        if data.isSelected {
            cell.playIcon.isHidden = false
        } else {
            cell.playIcon.isHidden = true
        }
        return cell
    }
}

extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        /// gak perlu ke vm karena ini view logic
        /// dan ada singleton untuk handle audio nya + handle view untuk play pause itu view logic
        let data = viewModel.allArtist.results[indexPath.row]
        viewModel.toggleRowSelected(index: indexPath.row, selected: true)
        
        guard let url = URL(string: data.previewURL) else { return }
        shouldShowAudioControl = shouldShowAudioControl == false
        nowPlaying = data
        AudioHelper.shared.playAudio(of: url)
        AudioHelper.shared.play()
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
