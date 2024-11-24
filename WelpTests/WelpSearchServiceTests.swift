//
//  WelpSearchServiceTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import CoreLocation
import XCTest
@testable import Welp

class WelpSearchServiceTests: XCTestCase {
    var mockRequestManager: MockRequestManager!
    var searchService: WelpSearchService!

    override func setUp() {
        super.setUp()
        mockRequestManager = MockRequestManager()
        searchService = WelpSearchService(requestManager: mockRequestManager)
    }

    override func tearDown() {
        mockRequestManager = nil
        searchService = nil
        super.tearDown()
    }

    func testSearchSuccess() async throws {
        mockRequestManager.data = MockJSONResponses.singleBusinessResponse

        let response = try await searchService.search(query: "test", location: nil, limit: 10, offset: 0)
        XCTAssertEqual(response.businesses.count, 1)
        XCTAssertEqual(response.businesses.first?.name, "Test Business")
    }

    func testSearchMultipleBusinesses() async throws {
        mockRequestManager.data = MockJSONResponses.multipleBusinessesResponse

        let response = try await searchService.search(query: "thai", location: nil, limit: 10, offset: 0)
        XCTAssertEqual(response.businesses.count, 2)
        XCTAssertEqual(response.businesses[0].name, "J's Noodles & Star Thai 2")
        XCTAssertEqual(response.businesses[1].name, "A&j Tire Factory & Service Center")
    }

    func testSearchFailure() async {
        mockRequestManager.error = URLError(.notConnectedToInternet)

        do {
            _ = try await searchService.search(query: "test", location: nil, limit: 10, offset: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testSearchInvalidJSONResponse() async {
        mockRequestManager.data = MockJSONResponses.invalidJson

        do {
            _ = try await searchService.search(query: "test", location: nil, limit: 10, offset: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is DecodingError)
        }
    }

    func testSearchEmptyResponse() async throws {
        mockRequestManager.data = MockJSONResponses.emptyResponse

        let response = try await searchService.search(query: "nonexistent", location: nil, limit: 10, offset: 0)
        XCTAssertEqual(response.businesses.count, 0)
    }

    func testSearchWithLocation() async throws {
        mockRequestManager.data = MockJSONResponses.singleBusinessResponse

        let location = CLLocation(latitude: 40.7128, longitude: -74.0060)
        let response = try await searchService.search(query: "test", location: location, limit: 10, offset: 0)
        XCTAssertEqual(response.businesses.count, 1)
        XCTAssertEqual(response.businesses.first?.name, "Test Business")
    }
}
