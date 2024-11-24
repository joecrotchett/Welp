//
//  MockRequest.swift
//  Welp
//
//  Created by Joseph Crotchett.
//  
//

@testable import Welp

struct MockRequest: RequestProtocol {
    var host: String { "example.com" }
    var path: String { "/test" }
    var requestType: RequestType { .GET }
    var headers: [String: String] { [:] }
    var params: [String: Any] { [:] }
    var urlParams: [String: String?] { [:] }
}
