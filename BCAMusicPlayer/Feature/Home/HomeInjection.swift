//
//  HomeInjection.swift
//  BCAMusicPlayer
//
//  Created by Benaya Oktavianus on 28/01/24.
//

import Foundation

final class HomeInjection {
    static func provideHomeViewController() -> HomeViewController {
        return HomeViewController(vm: provideHomeViewModel())
    }
    
    static func provideHomeViewModel() -> HomeViewModel {
        return DefaultHomeViewModel(repo: provideHomeRepo())
    }
    
    static func provideHomeRepo() -> HomeRepoProtocol {
        return HomeRepo(service: provideAPIManager())
    }
    
    static func provideAPIManager() -> APIManager {
        return APIManager()
    }
    
}
