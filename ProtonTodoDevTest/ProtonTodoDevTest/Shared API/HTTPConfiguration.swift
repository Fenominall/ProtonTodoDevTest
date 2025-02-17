//
//  HTTPConfiguration.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/17/25.
//

import Foundation

public struct HTTPConfiguration {
    let baseURL: URL?
    let baseHeaders: [String: String]
    
    public init(baseURL: URL?, baseHeaders: [String: String] = [:]) {
        self.baseURL = baseURL
        self.baseHeaders = baseHeaders
    }
    
    public static let `default` = HTTPConfiguration(baseURL: nil, baseHeaders: [:])
}
