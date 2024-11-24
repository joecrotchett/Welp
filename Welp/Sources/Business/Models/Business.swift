//
//  Business.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

// MARK: - Business

struct Business: Decodable {
    let id: String
    let alias: String
    let name: String
    let imageURL: String
    let url: String
    let rating: Double
    let isClosed: Bool

    enum CodingKeys: String, CodingKey {
        case id
        case alias
        case name
        case imageURL = "image_url"
        case url
        case rating
        case isClosed = "is_closed"
    }
}
