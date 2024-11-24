//
//  WelpBusinessRepositoryTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import XCTest
import CoreLocation
@testable import Welp

class WelpBusinessRepositoryTests: XCTestCase {
    var mockSearchService: MockSearchService!
    var mockLocationService: MockLocationService!
    var businessRepository: WelpBusinessRepository!

    override func setUp() {
        super.setUp()
        mockSearchService = MockSearchService()
        mockLocationService = MockLocationService()
        businessRepository = WelpBusinessRepository(searchService: mockSearchService, locationService: mockLocationService)
    }

    override func tearDown() {
        mockSearchService = nil
        mockLocationService = nil
        businessRepository = nil
        super.tearDown()
    }

    func testGetBusinessesSuccess() async throws {
        mockSearchService.data = MockJSONResponses.singleBusinessResponse
        mockLocationService.location = CLLocation(latitude: 40.7128, longitude: -74.0060)

        let businesses = try await businessRepository.getBusinesses(for: "test", limit: 10, offset: 0)
        XCTAssertEqual(businesses.count, 1)
        XCTAssertEqual(businesses.first?.name, "Test Business")
    }

    func testGetBusinessesMultipleResults() async throws {
        mockSearchService.data = MockJSONResponses.multipleBusinessesResponse
        mockLocationService.location = CLLocation(latitude: 39.7392, longitude: -104.9903)

        let businesses = try await businessRepository.getBusinesses(for: "thai", limit: 10, offset: 0)
        XCTAssertEqual(businesses.count, 2)
        XCTAssertEqual(businesses[0].name, "J's Noodles & Star Thai 2")
        XCTAssertEqual(businesses[1].name, "A&j Tire Factory & Service Center")
    }

    func testGetBusinessesFailure() async {
        mockSearchService.error = URLError(.notConnectedToInternet)

        do {
            _ = try await businessRepository.getBusinesses(for: "test", limit: 10, offset: 0)
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is URLError)
        }
    }

    func testGetBusinessesEmptyResponse() async throws {
        mockSearchService.data = """
        {
            "businesses": []
        }
        """.data(using: .utf8)!
        mockLocationService.location = CLLocation(latitude: 39.7392, longitude: -104.9903)

        let businesses = try await businessRepository.getBusinesses(for: "nonexistent", limit: 10, offset: 0)
        XCTAssertEqual(businesses.count, 0)
    }
}
