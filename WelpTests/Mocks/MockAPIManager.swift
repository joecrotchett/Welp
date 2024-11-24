//
//  MockAPIManager.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import Foundation
@testable import Welp

class MockAPIManager: APIManager {
    var data: Data?
    var error: Error?

    func perform(_ request: RequestProtocol) async throws -> Data {
        if let error = error {
            throw error
        }
        return data ?? Data()
    }
}
