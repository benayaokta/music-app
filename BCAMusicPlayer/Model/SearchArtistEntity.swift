//
//  SearchArtistEntity.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 28/01/24.
//

import Foundation

struct SearchArtistEntity {
    
    static func mapFromData(model: SearchArtistResult) -> SearchArtistEntity {
        return SearchArtistEntity(
            count: model.resultCount,
            results: model.results
                .map({ResultEntity(
                    name: $0.artistName ?? "",
                    songs: $0.trackName ?? "",
                    artworlURLString: $0.artworkUrl100 ?? "",
                    preview: $0.previewURL ?? "")}
                    )
        )
    }
    
    var count: Int
    var results: [ResultEntity]
    
    init() {
        self.count = 0
        self.results = []
    }
    
    init(count: Int, results: [ResultEntity]) {
        self.count = count
        self.results = results
    }
}


struct ResultEntity {
    var name: String
    var songs: String
    var artworlURLString: String
    var previewURL: String
    
    init(name: String, songs: String, artworlURLString: String, preview url: String) {
        self.name = name
        self.songs = songs
        self.artworlURLString = artworlURLString
        self.previewURL = url
    }
}
