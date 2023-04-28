//
//  CharacterListViewModel.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 24/4/23.
//

import Foundation

class CharacterListViewModel {
    var apiManager: APIManagerProtocol!

    var characters: [Character] = []

    init() {
    }

    func setApiManager(apiManager: APIManagerProtocol) {
        self.apiManager = apiManager
    }

    func fetchCharacters(completion: @escaping (Bool) -> Void) {
        apiManager.getCharacters { [weak self] result in
            switch result {
            case .success(let fetchedCharacters):
                self?.characters = fetchedCharacters
                completion(true)

            case .failure(let error):
                print("Error fetching characters: \(error)")
                completion(false)
            }
        }
    }
}
