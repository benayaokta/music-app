//
//  HomeRepo.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 28/01/24.
//

import Foundation

protocol HomeRepoProtocol {
    func searchArtist(name: String, listener: @escaping (SearchArtistEntity?, String?) -> Void)
}

final class HomeRepo: HomeRepoProtocol {
    
    var service: APIManager
    init(service: APIManager) {
        self.service = service
    }
    
    func searchArtist(name: String, listener: @escaping (SearchArtistEntity?, String?) -> Void) {
        service.request(config: APIConfiguration.searchArtist(name: name), model: SearchArtistResult.self) { result, error in
            guard error == nil else {
                listener(nil, error!)
                return
            }
            
            if let result, result.resultCount > 0 {
                let entity = SearchArtistEntity.mapFromData(model: result)
                listener(entity, nil)
            }
        }
    }
    
}
