//
//  DataParser.swift
//  Welp
//
//  Created by Joseph Crotchett
//  
//

import Foundation

// MARK: - DataParserProtocol

protocol DataParserProtocol {
    func parse<T: Decodable>(data: Data) throws -> T
}

// MARK: - DataParser

final class DataParser: DataParserProtocol {
    private var jsonDecoder: JSONDecoder

    init(jsonDecoder: JSONDecoder = JSONDecoder()) {
        self.jsonDecoder = jsonDecoder
        self.jsonDecoder.dateDecodingStrategy = .iso8601
    }

    func parse<T: Decodable>(data: Data) throws -> T {
        return try jsonDecoder.decode(T.self, from: data)
    }
}
