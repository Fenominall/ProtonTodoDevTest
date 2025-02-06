//
//  CombineHelpers.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

extension HTTPClient {
    typealias Publisher = AnyPublisher<HTTPResult, Error>
    
    func getPublisher(from url: URL) -> Publisher {
        var task: Task<Void, Never>?
        
        return Deferred {
            Future { promise in
                task = Task {
                    do {
                        let result = try await get(from: url)
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .handleEvents(receiveCancel: {
            task?.cancel()
        })
        .eraseToAnyPublisher()
    }
}

extension Publisher {
    func caching(to cache: TodoFeedCache) -> AnyPublisher<Output, Failure> where Output == [TodoItem] {
        handleEvents(receiveOutput: { feed in
            Task {
                await cache.saveIgnoringResult(feed)
            }
        })
        .eraseToAnyPublisher()
    }
}

private extension TodoFeedCache {
    func saveIgnoringResult(_ feed: [TodoItem]) async {
        try? await save(feed)
    }
}
