//
//  APIManager.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 27/01/24.
//

import Foundation
import Alamofire

final class APIManager {
    func request<T: Decodable>(config: URLRequestConvertible, model: T.Type, completion: @escaping (T?, String?) -> Void) {
        AF.cancelAllRequests()
        AF.request(config)
            .validate()
            .responseDecodable(of: T.self,
                               queue: DispatchQueue.global(qos: .background)
            ) { response in
                switch response.result {
                case .success(let value):
                    completion(value, nil)
                case .failure(let value):
                    completion(nil, value.localizedDescription)
                }
            }
    }
}
