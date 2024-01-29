//
//  HomeViewModel.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import Combine

protocol HomeViewModelInput {
    func sendSearchResult(text: String)
    func toggleRowSelected(index: Int, selected: Bool)
}

protocol HomeViewModelOutput {
    var allArtist: SearchArtistEntity { get }
    var shouldReload: PassthroughSubject<Bool, Never> { get }
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
    
    var allArtist: SearchArtistEntity = SearchArtistEntity()
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> = CurrentValueSubject<StateWrapper, Never>(.idle)
    var shouldReload: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    private var temporaryIndex: Int?
    
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
    
    private func clearData() {
        self.allArtist.results.removeAll()
        self.allArtist.count = 0
        self.shouldReload.send(true)
        self.viewResultWrapper.send(.resetState)
    }
}
