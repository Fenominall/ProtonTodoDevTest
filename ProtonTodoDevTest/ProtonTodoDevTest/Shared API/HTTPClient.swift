//
//  HTTPClient.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPResult = Data
    
    func sendRequest(endpoint: Endpoint) async throws -> Result<HTTPResult, RequestError>
}
