//
//  LoadFeedFromCacheUseCaseTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/18/25.
//

import Foundation
import ProtonTodoDevTest
import XCTest

class LoadFeedFromCacheUseCaseTests: XCTestCase {
    func test_init_deoesNotMessageStoreUponCreation() {
        let (_, store) = makeSUT()
        
        XCTAssertEqual(store.receivedMessaged, [])
    }
    
    func test_load_requestsCacheRetrieval() async throws {
        let (sut, store) = makeSUT()
        
        _ = try await sut.load()
        
        XCTAssertEqual(store.receivedMessaged, [.retrieve])
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
}
