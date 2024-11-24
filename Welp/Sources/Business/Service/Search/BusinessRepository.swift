//
//  BusinessRepository.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import UIKit

// MARK: - BusinessRepository

protocol BusinessRepository {
    func getBusinesses(for query: String, limit: Int, offset: Int) async throws -> [Business]
    func getImage(for urlString: String) async throws -> UIImage?
}

// MARK: - WelpBusinessRepository

final class WelpBusinessRepository: BusinessRepository {

    // MARK: Dependencise

    private let searchService: SearchService
    private let locationService: LocationService
    private let imageCache = NSCache<NSString, UIImage>()

    // MARK: Public Interface

    init(searchService: SearchService, locationService: LocationService) {
        self.searchService = searchService
        self.locationService = locationService
    }

    func getBusinesses(for query: String, limit: Int, offset: Int) async throws -> [Business] {
        let location = try? await locationService.getCurrentLocation()
        let response = try await searchService.search(query: query, location: location, limit: limit, offset: offset)
        return response.businesses
    }

    func getImage(for urlString: String) async throws -> UIImage? {
        if let cachedImage = imageCache.object(forKey: urlString as NSString) {
            return cachedImage
        }

        guard let url = URL(string: urlString) else { return nil }

        let (data, _) = try await URLSession.shared.data(from: url)
        if let image = UIImage(data: data) {
            imageCache.setObject(image, forKey: urlString as NSString)
            return image
        }

        return nil
    }
}
