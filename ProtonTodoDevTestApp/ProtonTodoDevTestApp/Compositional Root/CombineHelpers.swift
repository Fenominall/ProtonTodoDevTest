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
        // Since the received Output has the same signature with saveIngoringResult function,
        // it can be passed directly cache.saveIgnoringResult
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


extension LocalTodoFeedManager {
    typealias Publisher = AnyPublisher<[TodoItem], Error>
    
    func loadPublisher() -> Publisher {
        // A Deferred is a lazy publisher that awaits subscription before running.
        // So you can use it to wrap and make an eager publisher lazy.
        return Deferred {
            // Because the types match between LocalTodoFeedManager return result and the Future return result block
            // we can just path the load function for the completion parameter
            // in this the 'self' is the LocalTodoFeedManager itself
            Future { promise in
                Task {
                    do {
                        let result = try await self.load()
                        promise(.success(result))
                    } catch {
                        promise(.failure(error))
                    }
                }
            }
        }
        .eraseToAnyPublisher()
    }
}


extension Publisher {
    func fallback(to fallback: @escaping () -> AnyPublisher<Output, Failure>) -> AnyPublisher<Output, Failure> {
        // First, it tries to use the primary source (self). If the primary publisher produces an error, use fallbackPublisher.
        self.catch { _ in fallback()}.eraseToAnyPublisher()
    }
}
