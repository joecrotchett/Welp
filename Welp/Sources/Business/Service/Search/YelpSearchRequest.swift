//
//  TripRequest.swift
//  Welp
//
//  Created by Joseph Crotchett
//  
//

import Foundation
import CoreLocation

// MARK: - RequestProtocol

enum RequestType: String {
    case GET
    case POST
}

// MARK: - RequestProtocol

protocol RequestProtocol {
    var host: String { get }
    var path: String { get }
    var requestType: RequestType { get }
    var headers: [String: String] { get }
    var params: [String: Any] { get }
    var urlParams: [String: String?] { get }
}

// MARK: - Default RequestProtocol

extension RequestProtocol {
    var host: String {
        ""
    }

    var requestType: RequestType {
        return .GET
    }

    var params: [String: Any] {
        [:]
    }

    var urlParams: [String: String?] {
        [:]
    }

    var headers: [String: String] {
        [:]
    }

    func createURLRequest() throws -> URLRequest {
        var components = URLComponents()
        components.scheme = "https"
        components.host = host
        components.path = path
        components.queryItems = urlParams.map { URLQueryItem(name: $0, value: $1) }

        guard let url = components.url else { throw URLError(.badURL) }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = requestType.rawValue

        if !headers.isEmpty {
            urlRequest.allHTTPHeaderFields = headers
        }

        if !params.isEmpty {
            urlRequest.httpBody = try JSONSerialization.data(withJSONObject: params)
        }

        return urlRequest
    }
}

// MARK: YelpSearchRequest

enum YelpSearchRequest: RequestProtocol {
    case getBusinesses(query: String, location: CLLocation?, limit: Int, offset: Int)

    var headers: [String : String] {
        [
            "Content-Type" : "application/json",
            "Authorization" : "Bearer [add your key here]"
        ]
    }

    var host: String {
        "api.yelp.com"
    }

    var path: String {
        "/v3/businesses/search"
    }

    var urlParams: [String : String?] {
        switch self {
        case .getBusinesses(let query, let location, let limit, let offset):
            var params: [String: String?] = [
                "term": query,
                "sort_by": "best_match",
                "limit": "\(limit)",
                "offset": "\(offset)"
            ]
            if let location = location {
                params["latitude"] = "\(location.coordinate.latitude)"
                params["longitude"] = "\(location.coordinate.longitude)"
            } else {
                params["location"] = "denver"
            }
            return params
        }
    }
}
