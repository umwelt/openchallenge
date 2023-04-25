//
//  ErrorMockAPIManager.swift
//  OpenChallengeTests
//
//  Created by Hugo Perez on 25/4/23.
//

import XCTest
@testable import OpenChallenge

class ErrorMockAPIManager: APIManagerProtocol {
    enum MockError: Error {
        case testError
    }

    func getCharacters(completion: @escaping (Result<[Character], APIError>) -> Void) {
        completion(.failure(.networkError(MockError.testError)))
    }

    func getCharacterDetail(characterId: Int, completion: @escaping (Result<Character, Error>) -> Void) {
        completion(.failure(MockError.testError))
    }
}
