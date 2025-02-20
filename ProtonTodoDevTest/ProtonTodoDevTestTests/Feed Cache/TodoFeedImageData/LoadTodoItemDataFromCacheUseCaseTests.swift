//
//  LoadFeedImageDataFromCacheUseCaseTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest
import XCTest

class LoadTodoItemDataFromCacheUseCaseTests: XCTestCase {
    func test_init_doesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertTrue(store.receivedMessages.isEmpty)
    }

    func test_loadImgeFromURL_requestStoredDataFromURL() async throws {
        let (sut, store) = makeSUT()
        let imageURL = anyURL()
        let imageData = anyData()
            
        store.completeRetrieval(with: imageData)
        _ = try await sut.loadImage(from: imageURL)
        
        XCTAssertEqual(store.receivedMessages, [.retrieve(for: imageURL)])
    }
    
    func test_loadImgeFromURL_failsOnStoreError() async throws {
        let (sut, store) = makeSUT()
    
        await expect(sut, toCompleteWith: failed()) {
            let retrievalError = anyNSError()
            store.completeRetrieval(with: retrievalError)
        }
    }
    
    func test_loadImgeFromURL_deliversNotFoundErrorOnNotFound() async throws {
        let (sut, store) = makeSUT()
    
        await expect(sut, toCompleteWith: notFound()) {
            store.completeRetrieval(with: .none)
        }
    }
    
    func test_loadImgeFromURL_deliversStoreDataOnFoundDAta() async throws {
        let (sut, store) = makeSUT()
        let storeData = anyData()
    
        await expect(sut, toCompleteWith: .success(storeData)) {
            store.completeRetrieval(with: storeData)
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
    
    private typealias Result = Swift.Result<Data, Error>
    
    private func notFound() -> Result {
        return .failure(LocalTodoImageCachingManager.LoadError.notFound)
    }
    
    private func failed() -> Result {
        return .failure(LocalTodoImageCachingManager.LoadError.failed)
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
            let items = try await sut.loadImage(from: anyURL())
            receivedResult = .success(items)
        } catch {
            receivedResult = .failure(error)
        }
        
        switch (receivedResult, expectedResult) {
        case let (.success(receivedItems), .success(expectedItems)):
            XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
            
        case let (
            .failure(receivedError as LocalTodoImageCachingManager.LoadError),
            .failure(expectedError as LocalTodoImageCachingManager.LoadError)
        ):
            XCTAssertEqual(receivedError, expectedError, file: file, line: line)
        default:
            XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
        }
    }
}
