//
//  WelpSearchRequestTests.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import CoreLocation
import XCTest
@testable import Welp

class WelpSearchRequestTests: XCTestCase {

    func testGetBusinessesRequestURLParamsWithLocation() {
        let location = CLLocation(latitude: 39.7392, longitude: -104.9903)
        let request = YelpSearchRequest.getBusinesses(query: "thai", location: location, limit: 10, offset: 5)

        let urlParams = request.urlParams
        XCTAssertEqual(urlParams["term"], "thai")
        XCTAssertEqual(urlParams["sort_by"], "best_match")
        XCTAssertEqual(urlParams["limit"], "10")
        XCTAssertEqual(urlParams["offset"], "5")
        XCTAssertEqual(urlParams["latitude"], "39.7392")
        XCTAssertEqual(urlParams["longitude"], "-104.9903")
    }

    func testGetBusinessesRequestURLParamsWithoutLocation() {
        let request = YelpSearchRequest.getBusinesses(query: "sushi", location: nil, limit: 15, offset: 2)

        let urlParams = request.urlParams
        XCTAssertEqual(urlParams["term"], "sushi")
        XCTAssertEqual(urlParams["sort_by"], "best_match")
        XCTAssertEqual(urlParams["limit"], "15")
        XCTAssertEqual(urlParams["offset"], "2")
        XCTAssertEqual(urlParams["location"], "denver")
        XCTAssertNil(urlParams["latitude"] as Any?)
        XCTAssertNil(urlParams["longitude"] as Any?)
    }

    func testGetBusinessesRequestHeaders() {
        let request = YelpSearchRequest.getBusinesses(query: "coffee", location: nil, limit: 5, offset: 0)

        let headers = request.headers
        XCTAssertEqual(headers["Content-Type"], "application/json")
    }

    func testGetBusinessesRequestHost() {
        let request = YelpSearchRequest.getBusinesses(query: "pizza", location: nil, limit: 20, offset: 10)

        XCTAssertEqual(request.host, "api.yelp.com")
    }

    func testGetBusinessesRequestPath() {
        let request = YelpSearchRequest.getBusinesses(query: "burgers", location: nil, limit: 25, offset: 5)

        XCTAssertEqual(request.path, "/v3/businesses/search")
    }

    func testCreateURLRequest() throws {
        let location = CLLocation(latitude: 40.7128, longitude: -74.0060)
        let request = YelpSearchRequest.getBusinesses(query: "desserts", location: location, limit: 10, offset: 0)

        let urlRequest = try request.createURLRequest()

        XCTAssertEqual(urlRequest.url?.scheme, "https")
        XCTAssertEqual(urlRequest.url?.host, "api.yelp.com")
        XCTAssertEqual(urlRequest.url?.path, "/v3/businesses/search")
        XCTAssertEqual(urlRequest.url?.query?.contains("term=desserts"), true)
        XCTAssertEqual(urlRequest.url?.query?.contains("latitude=40.7128"), true)
        XCTAssertEqual(urlRequest.httpMethod, "GET")
        XCTAssertEqual(urlRequest.allHTTPHeaderFields?["Content-Type"], "application/json")
    }
}
