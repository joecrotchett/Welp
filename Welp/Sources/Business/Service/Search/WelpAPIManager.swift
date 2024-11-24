//
//  APIManager.swift
//  Welp
//
//  Created by Joseph Crotchett
//  
//

import Foundation

// MARK: APIManager

protocol APIManager {
    func perform(_ request: RequestProtocol) async throws -> Data
}

// MARK: WelpAPIManager

struct WelpAPIManager: APIManager {
    func perform(_ request: RequestProtocol) async throws -> Data {
        guard let request = try? request.createURLRequest() else { throw URLError(.badURL) }

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else { throw URLError(.badServerResponse) }
        return data
    }
}
