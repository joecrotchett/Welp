//
//  APIManagerTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import XCTest
@testable import Welp

class APIManagerTests: XCTestCase {
    var mockAPIManager: MockAPIManager!

    override func setUp() {
        super.setUp()
        mockAPIManager = MockAPIManager()
    }

    override func tearDown() {
        mockAPIManager = nil
        super.tearDown()
    }

    func testPerformRequestSuccess() async throws {
        let expectedData = "Test data".data(using: .utf8)!
        mockAPIManager.data = expectedData

        let request = MockRequest()
        let data = try await mockAPIManager.perform(request)

        XCTAssertEqual(data, expectedData)
    }

    func testPerformRequestFailure() async {
        mockAPIManager.error = URLError(.notConnectedToInternet)

        let request = MockRequest()
        do {
            _ = try await mockAPIManager.perform(request)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testPerformRequestEmptyData() async throws {
        mockAPIManager.data = Data()

        let request = MockRequest()
        let data = try await mockAPIManager.perform(request)

        XCTAssertTrue(data.isEmpty)
    }
}
