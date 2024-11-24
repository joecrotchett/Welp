//
//  RequestManager.swift
//  Welp
//
//  Created by Joseph Crotchett
//  
//

import Foundation

// MARK: - RequestManagerProtocol

protocol RequestManagerProtocol {
    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T
}

// MARK: - RequestManager

final class RequestManager: RequestManagerProtocol {
    let apiManager: APIManager
    let parser: DataParserProtocol

    init(
        apiManager: APIManager,
        parser: DataParserProtocol = DataParser()
    ) {
        self.apiManager = apiManager
        self.parser = parser
    }

    func perform<T: Decodable>(_ request: RequestProtocol) async throws -> T {
        let data = try await apiManager.perform(request)
        return try parser.parse(data: data)
    }
}
