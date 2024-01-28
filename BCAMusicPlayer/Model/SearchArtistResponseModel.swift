//
//  SearchArtistResponseModel.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation

// MARK: - SearchArtistResult
struct SearchArtistResult: Codable {
    let resultCount: Int
    let results: [Result]
    
    init() {
        self.resultCount = 0
        self.results = []
    }
}

// MARK: - Result
struct Result: Codable {
    let wrapperType: String?
    let kind: String?
    let artistID: Int?
    let collectionID, trackID: Int?
    let artistName, collectionName, trackName, collectionCensoredName: String?
    let trackCensoredName: String?
    let artistViewURL: String?
    let collectionViewURL, trackViewURL: String?
    let previewURL: String?
    let artworkUrl30, artworkUrl60, artworkUrl100: String?
    let collectionPrice: Double?
    let trackPrice: Double?
    let releaseDate: String?
    let collectionExplicitness, trackExplicitness: String?
    let discCount, discNumber: Int?
    let trackCount: Int?
    let trackNumber: Int?
    let trackTimeMillis: Int?
    let country: String?
    let currency: String?
    let primaryGenreName: String?
    let isStreamable: Bool?
    let contentAdvisoryRating: String?
    let collectionArtistName: String?
    let feedURL: String?
    let collectionHDPrice: Double?
    let artworkUrl600: String?
    let genreIDS, genres: [String]?

    enum CodingKeys: String, CodingKey {
        case wrapperType, kind
        case artistID = "artistId"
        case collectionID = "collectionId"
        case trackID = "trackId"
        case artistName, collectionName, trackName, collectionCensoredName, trackCensoredName
        case artistViewURL = "artistViewUrl"
        case collectionViewURL = "collectionViewUrl"
        case trackViewURL = "trackViewUrl"
        case previewURL = "previewUrl"
        case artworkUrl30, artworkUrl60, artworkUrl100, collectionPrice, trackPrice, releaseDate, collectionExplicitness, trackExplicitness, discCount, discNumber, trackCount, trackNumber, trackTimeMillis, country, currency, primaryGenreName, isStreamable, contentAdvisoryRating, collectionArtistName
        case feedURL = "feedUrl"
        case collectionHDPrice = "collectionHdPrice"
        case artworkUrl600
        case genreIDS = "genreIds"
        case genres
    }
}
