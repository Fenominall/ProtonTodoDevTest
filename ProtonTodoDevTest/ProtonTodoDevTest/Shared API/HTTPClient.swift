//
//  HTTPClient.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPResult = Result<(Data, HTTPURLResponse), RequestError>
    
    func sendRequest(endpoint: URL) async throws -> HTTPResult
}
