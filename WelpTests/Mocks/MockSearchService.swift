//
//  MockSearchService.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import CoreLocation
@testable import Welp

class MockSearchService: SearchService {
    var data: Data?
    var error: Error?

    func search(query: String, location: CLLocation?, limit: Int, offset: Int) async throws -> SearchResponse {
        if let error = error {
            throw error
        }
        guard let data = data else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(SearchResponse.self, from: data)
    }
}
