//
//  HTTPClient.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol HTTPClient {
    typealias HTTPResult = (Data, HTTPURLResponse)
    
    func get(from url: URL) async throws -> HTTPResult
}
