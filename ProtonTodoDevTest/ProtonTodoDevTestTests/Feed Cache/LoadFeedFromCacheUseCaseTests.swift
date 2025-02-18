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
