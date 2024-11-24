//
//  MockLocationService.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

import CoreLocation
@testable import Welp

class MockLocationService: LocationService {
    var location: CLLocation?
    var error: Error?

    func getCurrentLocation() async throws -> CLLocation {
        if let error = error {
            throw error
        }
        return location ?? CLLocation(latitude: 0, longitude: 0)
    }
}
