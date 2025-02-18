//
//  TodoFeedImageDataStoreSpy.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest

class TodoFeedImageStoreSpy: TodoFeedImageStore {
    enum ReceivedMessaged: Equatable {
        case retrieve(for: URL)
        case insert(data: Data, for: URL)
    }
    
    private(set) var receivedMessages = [ReceivedMessaged]()
    
    private var retrievalResult: Result<Data?, Error>?
    private var insertionResult: Result<Void, Error>?
    
    // MARK: - Retrieval
    func retrieve(from url: URL) async throws -> Data? {
        receivedMessages.append(.retrieve(for: url))
        return try retrievalResult?.get()
    }

    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
        
    func completeRetrieval(with data: Data?, at index: Int = 0) {
        retrievalResult = .success(data)
    }
    
    // MARK: - Insertion
    func cache(_ data: Data, for url: URL) async throws {
        receivedMessages.append(.insert(data: data, for: url))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
}
