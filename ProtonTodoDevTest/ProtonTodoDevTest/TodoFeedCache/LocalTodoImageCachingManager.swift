//
//  LocalTodoImageCachingManager.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class LocalTodoImageCachingManager {
    private let imageStore: TodoFeedImageStore
    
    public init(imageStore: TodoFeedImageStore) {
        self.imageStore = imageStore
    }
}

extension LocalTodoImageCachingManager: TodoImageLoader {
    enum LoadError: Error {
        case failed
        case notFound
    }
    public func loadImage(from url: URL) async throws -> Data {
        do {
            if let imageData = try await imageStore.retrieve(from: url) {
                return imageData
            }
        } catch {
            throw LoadError.failed
        }
        throw LoadError.notFound
    }
}

extension LocalTodoImageCachingManager: TodoImageCache {
    enum SaveError: Error {
        case failed
    }
    
    public func save(_ data: Data, for url: URL) async throws {
        do {
            try await imageStore.cache(data, for: url)
        } catch {
            throw SaveError.failed
        }
    }
}
