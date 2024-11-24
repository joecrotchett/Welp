//
//  WelpSearchViewModelTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//


import XCTest
import Combine
@testable import Welp

final class WelpSearchViewModelTests: XCTestCase {
    var mockRepository: MockBusinessRepository!
    var viewModel: WelpSearchViewModel!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        mockRepository = MockBusinessRepository()
        viewModel = WelpSearchViewModel(repository: mockRepository)
        cancellables = []
    }

    override func tearDown() {
        mockRepository = nil
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }

    func testSearchBusinessesSuccess() async {
        let expectedBusinesses = [
            Business(id: "1", alias: "test1", name: "Test Business 1", imageURL: "https://example.com/1.jpg", url: "https://example.com/1", rating: 4.5, isClosed: false),
            Business(id: "2", alias: "test2", name: "Test Business 2", imageURL: "https://example.com/2.jpg", url: "https://example.com/2", rating: 4.0, isClosed: false)
        ]
        mockRepository.businessesResult = .success(expectedBusinesses)

        let expectation = XCTestExpectation(description: "Businesses updated")
        viewModel.$businesses
            .drop { $0.isEmpty }
            .sink { businesses in
                XCTAssertEqual(businesses.count, expectedBusinesses.count)
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.searchBusinesses(query: "test")
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testSearchBusinessesFailure() async {
        mockRepository.businessesResult = .failure(URLError(.notConnectedToInternet))

        let expectation = XCTestExpectation(description: "Error message updated")
        viewModel.$errorMessage
            .dropFirst()
            .sink { errorMessage in
                XCTAssertEqual(errorMessage, "An error occurred while fetching businesses. Please try again.")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.searchBusinesses(query: "test")
        await fulfillment(of: [expectation], timeout: 1.0)
    }

    func testResetPagingOnNewSearch() async {
        let initialBusinesses = [
            Business(id: "1", alias: "test1", name: "Test Business 1", imageURL: "https://example.com/1.jpg", url: "https://example.com/1", rating: 4.5, isClosed: false)
        ]
        let newBusinesses = [
            Business(id: "2", alias: "test2", name: "Test Business 2", imageURL: "https://example.com/2.jpg", url: "https://example.com/2", rating: 4.0, isClosed: false)
        ]

        mockRepository.businessesResult = .success(initialBusinesses)
        await viewModel.searchBusinesses(query: "test")

        mockRepository.businessesResult = .success(newBusinesses)
        let expectation = XCTestExpectation(description: "Businesses reset and updated with new search")
        viewModel.$businesses
            .dropFirst(2)
            .sink { businesses in
                XCTAssertEqual(businesses.count, 1)
                XCTAssertEqual(businesses[0].name, "Test Business 2")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        await viewModel.searchBusinesses(query: "new test")
        await fulfillment(of: [expectation], timeout: 1.0)
    }
}
