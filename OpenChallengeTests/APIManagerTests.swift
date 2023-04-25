//
//  APIManagerTests.swift
//  OpenChallengeTests
//
//  Created by Hugo Perez on 24/4/23.
//

import XCTest
@testable import OpenChallenge

class APIManagerTests: XCTestCase {

    var apiManager: APIManagerProtocol!

    override func setUpWithError() throws {
        try super.setUpWithError()
        apiManager = MockAPIManager()
    }

    override func tearDownWithError() throws {
        apiManager = nil
        try super.tearDownWithError()
    }

    func testFetchCharacters() {
        let expectation = self.expectation(description: "Fetching characters")

        apiManager.getCharacters { result in
            switch result {
            case .success(let characters):
                XCTAssertNotNil(characters)
                XCTAssertGreaterThanOrEqual(characters.count, 1)

            case .failure(let error):
                XCTFail("Error fetching characters: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testGetCharacterDetail() {
        let expectation = self.expectation(description: "Fetching character detail")
        let testCharacterId = 1

        apiManager.getCharacterDetail(characterId: testCharacterId) { result in
            switch result {
            case .success(let character):
                XCTAssertNotNil(character)
                XCTAssertEqual(character.id, testCharacterId)

            case .failure(let error):
                XCTFail("Error fetching character detail: \(error)")
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchCharactersError() {
        let expectation = self.expectation(description: "Fetching characters error")

        let errorMockAPIManager = ErrorMockAPIManager()
        errorMockAPIManager.getCharacters { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                if case .networkError(let underlyingError) = error {
                    XCTAssertTrue(underlyingError is ErrorMockAPIManager.MockError)
                } else {
                    XCTFail("Expected networkError, but got \(error)")
                }
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }

    func testGetCharacterDetailError() {
        let expectation = self.expectation(description: "Fetching character detail error")

        let errorMockAPIManager = ErrorMockAPIManager()
        errorMockAPIManager.getCharacterDetail(characterId: 1) { result in
            switch result {
            case .success:
                XCTFail("Expected failure, but got success")
            case .failure(let error):
                XCTAssertTrue(error is ErrorMockAPIManager.MockError)
            }

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
