//
//  HTTPClient.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPResult = Result<Data, RequestError>
    
    func sendRequest(endpoint: Endpoint) async throws -> HTTPResult
}
