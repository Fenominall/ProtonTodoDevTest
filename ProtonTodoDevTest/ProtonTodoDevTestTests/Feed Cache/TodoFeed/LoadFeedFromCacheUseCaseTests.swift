//
//  LoadFeedFromCacheUseCaseTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest
import XCTest

final class LoadFeedFromCacheUseCaseTests: XCTestCase {
    func test_init_deoesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessages, [])
    }
    
    func test_load_requestsCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_failsOnRetrievalError() async throws {
        let (sut, store) = makeSUT()
        let retrievalError = anyNSError()

        await excpect(sut, toCompleteWith: .success([])) {
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_load_deliversNoTodoItemOnEmptyCache() async throws {
        let (sut, store) = makeSUT()
                
        await excpect(sut, toCompleteWith: .success([])) {
            store.completeRetrievalSuccessfullyWithEmptyCache()
        }
    }
    
    func test_load_hasNoSideEffectsOnRetrievalError() async throws {
        let (sut, store) = makeSUT()

        store.completeRetrieval(with: anyNSError())
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
    }
    
    func test_load_hasNoSideEffectsOnEmptyCache() async throws {
        let (sut, store) = makeSUT()
        
        store.completeRetrievalSuccessfullyWithEmptyCache()
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessages, [.retrieve])
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
        toCompleteWith expectedResult: Result<[TodoItem], Error>,
        when action: @escaping () async -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        await action()

        let receivedResult: Result<[TodoItem], Error>
        do {
            let items = try await sut.load()
            receivedResult = .success(items)
        } catch {
            receivedResult = .failure(error)
        }

        switch (receivedResult, expectedResult) {
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
        case let (.failure(receivedError as NSError), .failure(expectedError as NSError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
        }
    }
}
