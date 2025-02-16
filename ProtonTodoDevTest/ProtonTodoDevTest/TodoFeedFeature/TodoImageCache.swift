//
//  TodoImageCache.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoImageCache {
    func save(_ data: Data, for url: URL) async throws
}
