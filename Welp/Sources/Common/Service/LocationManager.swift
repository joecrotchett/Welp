//
//  LocationManager.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//


import CoreLocation
import Foundation

// MARK: - LocationService

protocol LocationService: AnyObject {
    func getCurrentLocation() async throws -> CLLocation
}

// MARK: - LocationManager

final class LocationManager: NSObject, LocationService {
    private let locationManager = CLLocationManager()
    private var locationContinuation: CheckedContinuation<CLLocation, Error>?
    private var cachedLocation: CLLocation?
    private var lastLocationUpdate: Date?

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }

    func getCurrentLocation() async throws -> CLLocation {
        if let cachedLocation = cachedLocation, let lastUpdate = lastLocationUpdate, Date().timeIntervalSince(lastUpdate) < 60 /*seconds*/ {
            return cachedLocation
        }

        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }

        guard locationManager.authorizationStatus == .authorizedWhenInUse ||
                locationManager.authorizationStatus == .authorizedAlways else {
            throw LocationError.notAuthorized
        }

        return try await withCheckedThrowingContinuation { continuation in
            self.locationContinuation?.resume(throwing: LocationError.cancelled)
            self.locationContinuation = continuation
            locationManager.startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            cachedLocation = location
            lastLocationUpdate = Date()
            locationContinuation?.resume(returning: location)
            locationContinuation = nil
            locationManager.stopUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationContinuation?.resume(throwing: error)
        locationContinuation = nil
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus == .denied {
            locationContinuation?.resume(throwing: LocationError.notAuthorized)
            locationContinuation = nil
        }
    }
}

// MARK: - LocationError

enum LocationError: Error {
    case notAuthorized
    case locationUnknown
    case cancelled
}
