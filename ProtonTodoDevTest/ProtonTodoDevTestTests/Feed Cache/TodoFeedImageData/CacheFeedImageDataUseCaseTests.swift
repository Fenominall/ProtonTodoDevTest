//
//  CacheFeedImageDataUseCaseTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

class CacheFeedImageDataUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }
    
    func test_saveImageDataForURL_requestStoredDataFromURL() async throws {
        let (sut, store) = makeSUT()
        let imageURL = anyURL()
        let imageData = anyData()
            
        try await sut.save(imageData, for: imageURL)
        
        XCTAssertEqual(store.receivedMessages, [.insert(data: imageData, for: imageURL)])
    }
    
    func test_saveImageDataForURL_failsOnInsertionError() async throws {
        let (sut, store) = makeSUT()
    
        await expect(sut, toCompleteWith: failed()) {
            let retrievalError = anyNSError()
            store.completeInsertion(with: retrievalError)
        }
    }
    
    func test_saveImageDataFromURL_succeedsOnSuccessfulStoreInsertion() async throws {
        let (sut, store) = makeSUT()
    
        await expect(sut, toCompleteWith: .success(())) {
            store.completeInsertionSuccessfully()
        }
    }
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) ->
    (sut: LocalTodoImageCachingManager, store: TodoFeedImageStoreSpy) {
        let store = TodoFeedImageStoreSpy()
        let sut = LocalTodoImageCachingManager(imageStore: store)
        trackForMemoryLeaks(store, file: file, line: line)
        trackForMemoryLeaks(sut, file: file, line: line)
        return (sut, store)
    }
    
    typealias Result = Swift.Result<Void, Error>
    
    private func failed() -> Result {
        return .failure(LocalTodoImageCachingManager.SaveError.failed)
    }
    
    private func expect(
        _ sut: LocalTodoImageCachingManager,
        toCompleteWith expectedResult: Result,
        when action: @escaping () async -> Void,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        await action()
        
        let receivedResult: Result
        do {
            try await sut.save(anyData(), for: anyURL())
            receivedResult = .success(())
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case (.success, .success):
            break
            
        case (.failure(let receivedError as LocalTodoImageCachingManager.SaveError),
              .failure(let expectedError as LocalTodoImageCachingManager.SaveError)):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
            
        default:
            XCTFail("Expected result \(expectedResult), got \(receivedResult) instead", file: file, line: line)
        }
    }
}
