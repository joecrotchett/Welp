//
//  MockJSONResponses.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

@testable import Welp

struct MockJSONResponses {

    static let invalidJson = "Invalid JSON".data(using: .utf8)
    
    static let emptyResponse = """
    {
        "businesses": []
    }
    """.data(using: .utf8)!

    static let singleBusinessResponse = """
    {
        "businesses": [
            {
                "id": "123",
                "alias": "test-business",
                "name": "Test Business",
                "image_url": "https://example.com/image.jpg",
                "url": "https://example.com",
                "rating": 4.5,
                "is_closed": false
            }
        ]
    }
    """.data(using: .utf8)!

    static let multipleBusinessesResponse = """
    {
        "businesses": [
            {
                "id": "kCfHyieJzaE37gtaEDRKsw",
                "alias": "js-noodles-and-star-thai-2-denver-2",
                "name": "J's Noodles & Star Thai 2",
                "image_url": "https://s3-media4.fl.yelpcdn.com/bphoto/TqWG8Bogl00kf142DRSflg/o.jpg",
                "is_closed": false,
                "url": "https://www.yelp.com/biz/js-noodles-and-star-thai-2-denver-2",
                "rating": 4.4
            },
            {
                "id": "IYX8XVFCvBIfqJj99Z0Ayw",
                "alias": "a-and-j-tire-factory-and-service-center-denver-2",
                "name": "A&j Tire Factory & Service Center",
                "image_url": "https://s3-media1.fl.yelpcdn.com/bphoto/ZQy2BtxdK1LtwYpjiJt3dw/o.jpg",
                "is_closed": false,
                "url": "https://www.yelp.com/biz/a-and-j-tire-factory-and-service-center-denver-2",
                "rating": 2.7
            }
        ]
    }
    """.data(using: .utf8)!
}
