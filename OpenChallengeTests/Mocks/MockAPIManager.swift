//
//  MockAPIManager.swift
//  OpenChallengeTests
//
//  Created by Hugo Perez on 24/4/23.
//

import XCTest
@testable import OpenChallenge

class MockAPIManager: APIManagerProtocol {
    func getCharacters(completion: @escaping (Result<[Character], APIError>) -> Void) {
        // Load mock data from a JSON file or create an array of mock Character objects here
        let character1 = Character(id: 1, name: "Character 1", description: "Sample character 1", modified: Date(), resourceURI: "https://example.com/1", urls: [], thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)
        let character2 = Character(id: 2, name: "Character 2", description: "Sample character 2", modified: Date(), resourceURI: "https://example.com/2", urls: [], thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)

        let characters = [character1, character2]

        // Call the completion handler with the mock data
        completion(.success(characters))
    }

    func getCharacterDetail(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        // Create a mock Character object with sample data
        let character = Character(id: characterId, name: "Character \(characterId)", description: "Sample character \(characterId)", modified: Date(), resourceURI: "https://example.com/\(characterId)", urls: [], thumbnail: nil, comics: nil, stories: nil, events: nil, series: nil)

        // Call the completion handler with the mock data
        completion(.success(character))
    }
}


extension MockAPIManager {
    private func loadMockDataFromFile() -> CharacterDataWrapper? {
        guard let url = Bundle(for: type(of: self)).url(forResource: "mockCharactersData", withExtension: "json") else {
            print("Failed to find mockCharactersData.json file")
            return nil
        }

        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            let characterDataWrapper = try decoder.decode(CharacterDataWrapper.self, from: data)
            return characterDataWrapper
        } catch {
            print("Failed to load and decode mockCharactersData.json: \(error)")
            return nil
        }
    }
}
