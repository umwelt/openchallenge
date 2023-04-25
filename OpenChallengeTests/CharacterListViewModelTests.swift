//
//  CharacterListViewModelTests.swift
//  OpenChallengeTests
//
//  Created by Hugo Perez on 24/4/23.
//

import XCTest
@testable import OpenChallenge

final class CharacterListViewModelTests: XCTestCase {

    var viewModel: CharacterListViewModel!
    var mockAPIManager: MockAPIManager!

    override func setUpWithError() throws {
        try super.setUpWithError()
        mockAPIManager = MockAPIManager()
        viewModel = CharacterListViewModel(apiManager: mockAPIManager)
    }

    override func tearDownWithError() throws {
        viewModel = nil
        mockAPIManager = nil
        try super.tearDownWithError()
    }

    func testFetchCharacters() {
        let expectation = self.expectation(description: "Fetching characters")

        viewModel.fetchCharacters { success in
            XCTAssertTrue(success)

            XCTAssertEqual(self.viewModel.characters.count, 2)
            XCTAssertEqual(self.viewModel.characters[0].id, 1)
            XCTAssertEqual(self.viewModel.characters[0].name, "Character 1")
            XCTAssertEqual(self.viewModel.characters[1].id, 2)
            XCTAssertEqual(self.viewModel.characters[1].name, "Character 2")

            expectation.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
    }
}
