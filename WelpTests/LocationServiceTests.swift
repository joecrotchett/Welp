//
//  LocationServiceTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import CoreLocation
import XCTest
@testable import Welp

class LocationServiceTests: XCTestCase {
    var mockLocationService: MockLocationService!

    override func setUp() {
        super.setUp()
        mockLocationService = MockLocationService()
    }

    override func tearDown() {
        mockLocationService = nil
        super.tearDown()
    }

    func testGetCurrentLocationSuccess() async throws {
        let expectedLocation = CLLocation(latitude: 37.7749, longitude: -122.4194)
        mockLocationService.location = expectedLocation

        let location = try await mockLocationService.getCurrentLocation()
        XCTAssertEqual(location.coordinate.latitude, expectedLocation.coordinate.latitude)
        XCTAssertEqual(location.coordinate.longitude, expectedLocation.coordinate.longitude)
    }

    func testGetCurrentLocationFailure() async {
        mockLocationService.error = LocationError.notAuthorized

        do {
            _ = try await mockLocationService.getCurrentLocation()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is LocationError)
            XCTAssertEqual(error as? LocationError, LocationError.notAuthorized)
        }
    }

    func testGetCurrentLocationDefault() async throws {
        let location = try await mockLocationService.getCurrentLocation()
        XCTAssertEqual(location.coordinate.latitude, 0)
        XCTAssertEqual(location.coordinate.longitude, 0)
    }

    func testGetCurrentLocationUpdate() async throws {
        let initialLocation = CLLocation(latitude: 0, longitude: 0)
        mockLocationService.location = initialLocation

        var location = try await mockLocationService.getCurrentLocation()
        XCTAssertEqual(location.coordinate.latitude, 0)
        XCTAssertEqual(location.coordinate.longitude, 0)

        let updatedLocation = CLLocation(latitude: 51.5074, longitude: -0.1278)
        mockLocationService.location = updatedLocation

        location = try await mockLocationService.getCurrentLocation()
        XCTAssertEqual(location.coordinate.latitude, updatedLocation.coordinate.latitude)
        XCTAssertEqual(location.coordinate.longitude, updatedLocation.coordinate.longitude)
    }

    func testGetCurrentLocationNilLocationFailure() async {
        mockLocationService.location = nil
        mockLocationService.error = LocationError.locationUnknown

        do {
            _ = try await mockLocationService.getCurrentLocation()
            XCTFail("Expected error to be thrown")
        } catch {
            XCTAssertTrue(error is LocationError)
            XCTAssertEqual(error as? LocationError, LocationError.locationUnknown)
        }
    }
}
