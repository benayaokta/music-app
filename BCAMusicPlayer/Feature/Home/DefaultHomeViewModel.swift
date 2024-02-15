//
//  HomeViewModel.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import Combine
import CoreExtension

protocol HomeViewModelInput {
    func sendSearchResult(text: String)
    func toggleRowSelected(index: Int, selected: Bool)
    func setCurrentPlayingIndex(index: Int)
    func goToNextTrack()
    func goToPrevTrack()
}

protocol HomeViewModelOutput {
    var allArtist: SearchArtistEntity { get }
    var shouldReload: PassthroughSubject<Bool, Never> { get }
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> { get }
    var shouldPlaySong: PassthroughSubject<ResultEntity?, Never> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
    
    var allArtist: SearchArtistEntity = SearchArtistEntity()
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> = CurrentValueSubject<StateWrapper, Never>(.idle)
    var shouldReload: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    private var currentPlayingIndex: Int?
    
    private var temporaryIndex: Int?
    var shouldPlaySong: PassthroughSubject<ResultEntity?, Never> = PassthroughSubject<_, Never>()
    private var cancellables: Set<AnyCancellable> = []
    
    var repo: HomeRepoProtocol
    init(repo: HomeRepoProtocol) {
        self.repo = repo
    }
    
    func sendSearchResult(text: String) {
        if text == "" {
            self.clearData()
        } else {
            viewResultWrapper.send(.loading)
            repo.searchArtist(name: text) { [weak self] entity, error in
                self?.viewResultWrapper.send(.idle)
                self?.viewResultWrapper.send(.hideEmptyView)
                if let entity, entity.count > 0 {
                    self?.allArtist = entity
                } else {
                    self?.viewResultWrapper.send(.showAlert(message: "Search result not found"))
                }
                
                if let error {
                    self?.viewResultWrapper.send(.showAlert(message: error))
                }
                self?.shouldReload.send(true)
            }
        }
    }
    
    func toggleRowSelected(index: Int, selected: Bool) {
        if temporaryIndex == nil {
            self.allArtist.results[index].isSelected = selected
            temporaryIndex = index
        } else if temporaryIndex != nil {
            if temporaryIndex != index {
                self.allArtist.results[temporaryIndex!].isSelected = false
                self.allArtist.results[index].isSelected = selected
                temporaryIndex = index
            }
        }
        
        shouldReload.send(true)
    }
    
    func setCurrentPlayingIndex(index: Int) {
        self.currentPlayingIndex = index
    }
    
    func goToPrevTrack() {
        if let currentPlayingIndex {
            let prevIndex = currentPlayingIndex - 1
            if allArtist.results[safe: prevIndex] != nil {
                self.currentPlayingIndex = prevIndex
                shouldPlaySong.send(allArtist.results[safe: prevIndex])
                toggleRowSelected(index: prevIndex, selected: true)
            }
        }
    }
    
    func goToNextTrack() {
        if let currentPlayingIndex {
            let nextIndex = currentPlayingIndex + 1
            if allArtist.results[safe: nextIndex] != nil {
                self.currentPlayingIndex = nextIndex
                shouldPlaySong.send(allArtist.results[safe: nextIndex])
                toggleRowSelected(index: nextIndex, selected: true)
            }
        }
    }
    
}

extension DefaultHomeViewModel {
    
    private func clearData() {
        self.allArtist.results.removeAll()
        self.allArtist.count = 0
        self.shouldReload.send(true)
        self.viewResultWrapper.send(.resetState)
    }
}
