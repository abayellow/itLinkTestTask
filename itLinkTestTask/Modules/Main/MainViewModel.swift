//
//  MainViewModel.swift
//  itLinkTestTask
//
//  Created by Alexander Abanshin on 17.11.2025.
//

import Foundation

final class MainViewModel {    
    private let networkService = NetworkService()
    
    var onDataLoaded: (([URL]) -> Void)?
    
    func loadImages() {
        Task {
            do {
                let urls = try await networkService.loadImageURLs(from: API.stringURL)
                self.onDataLoaded?(urls)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
}
