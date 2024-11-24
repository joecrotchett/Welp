//
//  WelpSearchViewModel.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import Foundation
import Combine

// MARK: - WelpSearchViewModel

final class WelpSearchViewModel {

    private var cancellables: Set<AnyCancellable> = []
    private var currentOffset: Int = 0
    private let limit: Int = 15

    init(repository: BusinessRepository) {
        self.repository = repository
    }

    // MARK: View Dependencies

    private let repository: BusinessRepository

    // MARK: View State

    @Published private(set) var businesses: [Business] = []
    @Published private(set) var errorMessage: String?

    // MARK: View Actions

    func searchBusinesses(query: String, resetPaging: Bool = true) async {
        if resetPaging {
            currentOffset = 0
            businesses = []
        }

        do {
            let fetchedBusinesses = try await self.repository.getBusinesses(for: query, limit: limit, offset: currentOffset)
            self.businesses.append(contentsOf: fetchedBusinesses)
            currentOffset += limit
        } catch {
            self.errorMessage = String(localized: "An error occurred while fetching businesses. Please try again.")
        }
    }

    func loadNextPage(query: String) async {
        await searchBusinesses(query: query, resetPaging: false)
    }
}
