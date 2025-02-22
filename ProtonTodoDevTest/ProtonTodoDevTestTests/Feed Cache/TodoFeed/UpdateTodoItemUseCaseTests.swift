//
//  UpdateTodoItemUseCaseTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest
import XCTest

final class UpdateTodoItemUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() async {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_save_failsOnSingleItemInsertionError() async throws {
        let (sut, store) = makeSUT()
        let insertionError = anyNSError()
        
        await excpect(sut, toCompleteWith: insertionError) {
            store.completeInsertion(with: insertionError)
        }
    }
    
    func test_save_succeedsOnSingleItemInsertionSuccess() async throws {
        let (sut, store) = makeSUT()
        
        await excpect(sut, toCompleteWith: nil) {
            store.completeInsertionSuccessfully()
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) ->
    (sut: LocalTodoFeedManager, store: TodoFeedStoreSpy) {
        let store = TodoFeedStoreSpy()
        let sut = LocalTodoFeedManager(store: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    private func excpect(
        _ sut: LocalTodoFeedManager,
        toCompleteWith expectedError: NSError?,
        when action: @escaping () async -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        await action()

        do {
            try await sut.save(uniqueItem())
        } catch  {
            XCTAssertEqual(error as NSError?, expectedError, file: file, line: line)
        }
    }
}
