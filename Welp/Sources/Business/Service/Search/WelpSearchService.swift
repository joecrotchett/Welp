//
//  WelpSearchService.swift
//  Welp
//
//  Created by Joseph Crotchett
//  
//

import CoreLocation

// MARK: - SearchService

protocol SearchService {
    func search(query: String, location: CLLocation?, limit: Int, offset: Int) async throws -> SearchResponse
}

// MARK: - WelpSearchService

struct WelpSearchService: SearchService {
    private let requestManager: RequestManagerProtocol

    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }

    func search(query: String, location: CLLocation?, limit: Int, offset: Int) async throws -> SearchResponse {
        let response: SearchResponse = try await requestManager.perform(YelpSearchRequest.getBusinesses(query: query, location: location, limit: limit, offset: offset))
        return response
    }
}
