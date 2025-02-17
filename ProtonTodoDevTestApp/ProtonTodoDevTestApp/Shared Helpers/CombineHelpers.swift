//
//  CombineHelpers.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

// MARK: - API Helpers
extension HTTPClient {
    typealias Publisher = AnyPublisher<Data, RequestError>
    
    func getPublisher(from endpoint: Endpoint) -> Publisher {
        var task: Task<Void, Never>?
        
        return Deferred {
            Future { promise in
                task = Task {
                    do {
                        let result = try await sendRequest(endpoint: endpoint)
                        switch result {
                        case .success(let data):
                            promise(.success(data))
                        case .failure(let error):
                            promise(.failure(error))
                        }
                    } catch {
                        promise(
                            .failure(
                                error as? RequestError ?? .unknown(error.localizedDescription)
                            )
                        )
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

// MARK: - Cahcing Helpers
extension Publisher {
    func caching(to cache: TodoFeedCache) -> AnyPublisher<Output, Failure> where Output == [TodoItem] {
        // Since the received Output has the same signature with saveIngoringResult function,
        // it can be passed directly cache.saveIgnoringResult
        handleEvents(receiveOutput: { feed in
            Task {
                try await cache.save(feed)
            }
        })
        .eraseToAnyPublisher()
    }
}

// MARK: - Cahcing Helpers
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

extension TodoImageLoader {
    typealias Publisher = AnyPublisher<Data, Error>
    
    func loadImageDataPublisher(from url: URL) -> Publisher {
        return Deferred {
            Future { promise in
                Task {
                    do {
                        let data = try await loadImage(from: url)
                        promise(.success(data))
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
    func caching(to cache: TodoImageCache, using url: URL) -> AnyPublisher<Output, Failure> where Output == Data {
        // Since the received Output has the same signature with saveIngoringResult function,
        // it can be passed directly cache.saveIgnoringResult
        handleEvents(receiveOutput: { data in
            Task {
                try await cache.save(data, for: url)
            }
        })
        .eraseToAnyPublisher()
    }
}
