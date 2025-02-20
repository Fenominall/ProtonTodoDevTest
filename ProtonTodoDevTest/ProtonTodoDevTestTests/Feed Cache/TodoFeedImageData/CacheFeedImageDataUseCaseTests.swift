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
