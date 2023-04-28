//
//  CharacterDetailViewModel.swift
//  OpenChallenge
//
//  Created by Hugo Perez on 28/4/23.
//

import Foundation

import Foundation

class CharacterDetailViewModel {
    private let apiManager: APIManagerProtocol
    private let characterId: Int
    var character: Character?
    
    init(apiManager: APIManagerProtocol, characterId: Int) {
        self.apiManager = apiManager
        self.characterId = characterId
    }
    
    func getCharacterDetail(completion: @escaping (Result<Character, Error>) -> Void) {
        apiManager.getCharacterDetail(characterId: characterId) { [weak self] result in
            guard let self = self else { return }
            
            DispatchQueue.main.async {
                switch result {
                case .success(let character):
                    self.character = character
                    completion(.success(character))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
    
    var name: String? {
        return character?.name
    }
    
    var description: String? {
        return character?.description
    }
    
    var thumbnailURL: URL? {
        guard let thumbnail = character?.thumbnail,
              let url = URL(string: "\(thumbnail.path ?? "").\(thumbnail.fileExtension ?? "")") else {
            return nil
        }
        return url
    }
}

