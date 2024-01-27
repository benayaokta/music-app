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
    func clearData()
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
        viewResultWrapper.send(.loading)
        APIManager().request(config: APIConfiguration.searchArtist(name: text), model: SearchArtistResult.self) { [weak self] data, error in
            self?.viewResultWrapper.send(.idle)
            if let data, data.resultCount > 0 {
                var names: [String] = []
                data.results.forEach({names.append($0.artistName ?? "")})
                let temporarySet = Set(names)
                self?.allArtist.append(contentsOf: temporarySet)
                self?.shouldReload.send(true)
            } else {
                print("||| not found")
            }
            
            if let error {
                print("||| error \(error)")
            }
            
        }
    }
    
    func clearData() {
        self.allArtist.removeAll()
        self.shouldReload.send(true)
    }
    
}
