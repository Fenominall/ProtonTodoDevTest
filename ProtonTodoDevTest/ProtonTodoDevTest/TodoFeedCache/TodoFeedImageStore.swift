//
//  TodoFeedimageStore.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoFeedImageStore {
    func cache(_ data: Data, for url: URL) async throws
    func retrieve(from url: URL) async throws -> Data?
}
