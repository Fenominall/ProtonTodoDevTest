//
//  CoreDataFeedStoreTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

typealias CoreDataFeedStoreSpecs = RetrieveStoreSpecs & FailableRetrieveStoreSpecs & InsertStoreSpecs & FailableInsertStoreSpecs & UpdateStoreSpecs & FailableUpdateStoreSpecs

final class CoreDataFeedStoreTests: XCTestCase, CoreDataFeedStoreSpecs  {    
    // MARK: - Retrieve
    func test_retrieve_deliversEmptyOnEmptyStore() async throws {
        let sut = makeSUT()
        
        try await expect(sut, toRetreive: .success(.none))
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyStore() async throws {
        let sut = makeSUT()
        
        try await expect(sut, toRetreive: .success(.none))
        try await expect(sut, toRetreive: .success(.none))
    }
    
    func test_retrieve_deliversDataOnNonEmptyStore() async throws {
        let sut = makeSUT()
        let todoFeed = uniqueTodoItems()
        
        try await sut.insert(todoFeed.local)
        
        try await expect(sut, toRetreive: .success(todoFeed.local))
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() async throws {
        let sut = makeSUT()
        let todoFeed = uniqueTodoItems()
        
        try await insert(todoFeed.local, to: sut)
        
        try await expect(sut, toRetreive: .success(todoFeed.local))
        try await expect(sut, toRetreive: .success(todoFeed.local))
    }
    
    // MARK: - Failable Retrieve
    func test_retrieve_deliversFailureOnError() async throws {
        let sut = makeFailingSUT()
        let retrievalError = anyNSError()
        
        sut.completeRetrieval(with: retrievalError)
        
        try await expect(sut, toRetreive: .failure(retrievalError))
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() async throws {
        let sut = makeFailingSUT()
        let retrievalError = anyNSError()
        
        sut.completeRetrieval(with: retrievalError)
        
        try await expect(sut, toRetreive: .failure(retrievalError))
        try await expect(sut, toRetreive: .failure(retrievalError))
    }
    
    // MARK: - Insert
    func test_insert_succeedsOnEmptyStore() async throws {
        let sut = makeSUT()
        let todoFeed = uniqueTodoItems()
        
        let insertionError = try await insert(todoFeed.local, to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_succeedsOnNonEmptyStore() async throws {
        let sut = makeSUT()
        try await insert(uniqueTodoItems().local, to: sut)
        
        let insertionError = try await insert(uniqueTodoItems().local, to: sut)
        
        XCTAssertNil(insertionError, "Expected to insert cache successfully")
    }
    
    func test_insert_updatesExistingItemsAndAddsNewOnes() async throws {
        let sut = makeSUT()
        let initialFeed = uniqueTodoItems().local
        try await insert(initialFeed, to: sut)
        
        var updatedItem = initialFeed[0]
        updatedItem.completed = !updatedItem.completed
        let newItem = uniqueLocalItem()
        let latestFeed = [updatedItem, newItem]
        try await insert(latestFeed, to: sut)
        
        let expectedFeed = [updatedItem, initialFeed[1], newItem]

        try await expect(sut, toRetreive: .success(expectedFeed))
    }
    
    // MARK: - Failable Insert
    func test_insert_deliversFailureOnError() async throws {
        let sut = makeFailingSUT()
        let expectedError = anyNSError()
        
        sut.completeInsertion(with: expectedError)
        let receivedError = try await insert(uniqueTodoItems().local, to: sut)
        
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    func test_insert_hasNoSideEffectsOnFailure() async throws {
        let sut = makeFailingSUT()
        let insertionError = anyNSError()
        sut.completeInsertion(with: insertionError)
        
        let receivedError = try await insert(uniqueTodoItems().local, to: sut)
        XCTAssertNotNil(receivedError, "Expected insertion to fail")
        
        try await expect(sut, toRetreive: .success(.none))
    }
    
    // MARK: - Update
    func test_update_succeedsOnNonEmptyStore() async throws {
        let sut = makeSUT()
        let localTodoItem = uniqueLocalItem()
        
        try await insert([localTodoItem], to: sut)
        
        let updatingError = try await update(localTodoItem, to: sut)
        
        XCTAssertNil(updatingError, "Expected to update item successfully")
    }
    
    func test_update_modifiesExistingData() async throws {
        let sut = makeSUT()
        let localTodoItem = uniqueLocalItem()
        
        try await insert([localTodoItem], to: sut)
        
        var updtedItem = localTodoItem
        updtedItem.completed = false
        let updatingError = try await update(updtedItem, to: sut)
        
        XCTAssertNil(updatingError, "Expected to update item successfully")
        try await expect(sut, toRetreive: .success([updtedItem]))
    }
    
    func test_update_deliversNotFoundErrorOnEmptyStore() async throws {
        let sut = makeSUT()
        
        let itemToUpdate = uniqueLocalItem()
        let updateError = try await update(itemToUpdate, to: sut)
        
        XCTAssertNotNil(updateError, "Expected update to succeed with no effect")
        try await expect(sut, toRetreive: .success(.none))
    }
    
    func test_update_deliversFailureOnError() async throws {
        let sut = makeFailingSUT()
        let expectedError = anyNSError()
        
        sut.completeUpdating(with: expectedError)
        let receivedError = try await update(uniqueLocalItem(), to: sut)
        
        XCTAssertEqual(receivedError as NSError?, expectedError)
    }
    
    func test_update_hasNoSideEffectsOnFailure() async throws {
        let sut = makeFailingSUT()
        let updatingError = anyNSError()
        sut.completeUpdating(with: updatingError)
        
        let receivedError = try await update(uniqueLocalItem(), to: sut)
        XCTAssertNotNil(receivedError, "Expected updating to fail")
        
        try await expect(sut, toRetreive: .success(.none))
    }
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> TodoFeedStore {
        let storeURL = URL(filePath: "/dev/null")!
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func makeFailingSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> TodoFeedStoreSpy {
        let sut = TodoFeedStoreSpy()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    @discardableResult
    private func insert(
        _ cache: [LocalTodoItem],
        to sut: TodoFeedStore
    ) async throws -> Error? {
        var insertionError: Error?
        do {
            try await sut.insert(cache)
        } catch {
            insertionError = error
        }
        return insertionError
    }
    
    @discardableResult
    private func update(
        _ item: LocalTodoItem,
        to sut: TodoFeedStore
    ) async throws -> Error? {
        var insertionError: Error?
        do {
            try await sut.update(item)
        } catch {
            insertionError = error
        }
        return insertionError
    }
    
    typealias LoadResult = Result<[LocalTodoItem]?, Error>
    
    private func expect(
        _ sut: TodoFeedStore,
        toRetreive expectedResult: LoadResult,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async throws {
        let receivedResult: LoadResult
        
        do {
            let items = try await sut.retrieve()
            receivedResult = .success(items)
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (expectedResult, receivedResult) {
        case (.success(.none), .success(.none)),
            (.failure, .failure):
            break
        case let (.success(.some(expected)), .success(.some(retrieved))):
            XCTAssertEqual(retrieved, expected, file: file, line: line)
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
