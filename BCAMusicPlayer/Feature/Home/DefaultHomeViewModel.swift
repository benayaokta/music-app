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
}

protocol HomeViewModelOutput {
    var allArtist: [String] { get }
    var shouldReload: PassthroughSubject<Bool, Never> { get }
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> { get }
}

protocol HomeViewModel: HomeViewModelInput, HomeViewModelOutput { }

final class DefaultHomeViewModel: HomeViewModel {
    
    var allArtist: [String] = []
    var viewResultWrapper: CurrentValueSubject<StateWrapper, Never> = CurrentValueSubject<StateWrapper, Never>(.idle)
    var shouldReload: PassthroughSubject<Bool, Never> = PassthroughSubject<Bool, Never>()
    
    private var cancellables: Set<AnyCancellable> = []
    
    func sendSearchResult(text: String) {
        if text == "" {
            self.clearData()
        } else {
            viewResultWrapper.send(.loading)
            APIManager().request(config: APIConfiguration.searchArtist(name: text), model: SearchArtistResult.self) { [weak self] data, error in
                self?.viewResultWrapper.send(.idle)
                self?.viewResultWrapper.send(.hideEmptyView)
                if let data, data.resultCount > 0 {
                    var names: [String] = []
                    data.results.forEach({names.append($0.artistName ?? "")})
                    let temporarySet = Set(names)
                    self?.allArtist.append(contentsOf: temporarySet)
                } else {
                    self?.viewResultWrapper.send(.showAlert(message: "Search result not found"))
                }
                
                if let error {
                    self?.viewResultWrapper.send(.showAlert(message: error.localizedDescription))
                }
                self?.shouldReload.send(true)
            }
        }
        
    }
    
    private func clearData() {
        self.allArtist.removeAll()
        self.shouldReload.send(true)
        self.viewResultWrapper.send(.resetState)
    }
    
}
