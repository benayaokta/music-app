//
//  APIConfiguration.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import Alamofire


enum APIConfiguration: URLRequestConvertible {
    
    case searchArtist(name: String)
    
    var baseURL: String {
        return "https://itunes.apple.com"
    }
    
    var path: String {
        switch self {
        case .searchArtist:
            return "/search"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parameters: Parameters? {
        switch self {
        case .searchArtist(let name):
            return [
                "term": name,
            ]
        }
    }
    
    var encoding: ParameterEncoding {
        return URLEncoding(destination: .queryString)
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try baseURL.asURL()
        var request = URLRequest(url: url.appendingPathComponent(path))
        request.httpMethod = method.rawValue
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
