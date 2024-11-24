//
//  MockBusinessRepository.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit
@testable import Welp

final class MockBusinessRepository: BusinessRepository {
    var businessesResult: Result<[Business], Error> = .success([])

    func getBusinesses(for query: String, limit: Int, offset: Int) async throws -> [Business] {
        switch businessesResult {
        case .success(let businesses):
            return businesses
        case .failure(let error):
            throw error
        }
    }

    func getImage(for urlString: String) async throws -> UIImage? {
        return nil
    }
}
