//
//  TodoFeedStoreSpy.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import ProtonTodoDevTest

final class TodoFeedStoreSpy: TodoFeedStore {
    enum ReceivedMessaged: Equatable {
        case retrieve
        case insert([LocalTodoItem])
        case update(LocalTodoItem)
    }
    
    private(set) var receivedMessages = [ReceivedMessaged]()
    
    private var retrievalResult: Result<[LocalTodoItem], Error>?
    private var insertionResult: Result<Void, Error>?
    private var updatingResult: Result<Void, Error>?
    
    // MARK: - Retrieval
    func retrieve() async throws -> [LocalTodoItem]? {
        receivedMessages.append(.retrieve)
        switch retrievalResult {
        case .success(let items):
            return items
        case .failure(let error):
            throw error
        case .none:
            return nil
        }
    }
    
    func completeRetrieval(with error: Error, at index: Int = 0) {
        retrievalResult = .failure(error)
    }
    
    func completeRetrievalSuccessfullyWithEmptyCache(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    func completeRetrieval(with feed: [LocalTodoItem], at index: Int = 0) {
        retrievalResult = .success(feed)
    }
    
    // MARK: - Insertion
    func insert(_ feed: [LocalTodoItem]) async throws {
        receivedMessages.append(.insert(feed))
        try insertionResult?.get()
    }
    
    func completeInsertion(with error: Error, at index: Int = 0) {
        insertionResult = .failure(error)
    }
    
    func completeInsertionSuccessfully(at index: Int = 0) {
        insertionResult = .success(())
    }
    
    // MARK: - Updating
    func update(_ item: LocalTodoItem) async throws {
        receivedMessages.append(.update(item))
        try updatingResult?.get()
    }
    
    func completeUpdating(with error: Error, at index: Int = 0) {
        updatingResult = .failure(error)
    }
    
    func completeUpdatingSuccessfully(at index: Int = 0) {
        updatingResult = .success(())
    }
}
