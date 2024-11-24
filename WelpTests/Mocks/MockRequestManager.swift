//
//  MockRequestManager.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import Foundation
@testable import Welp

class MockRequestManager: RequestManagerProtocol {
    var data: Data?
    var error: Error?

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        if let error = error {
            throw error
        }
        guard let data = data else { throw URLError(.badServerResponse) }
        return try JSONDecoder().decode(T.self, from: data)
    }
}
