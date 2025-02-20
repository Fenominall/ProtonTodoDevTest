//
//  CoreDataFeedImageDataStoreTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

final class CoreDataFeedImageDataStoreTests: XCTestCase {
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> CoreDataFeedStore {
        let storeURL = URL(filePath: "/dev/null")
        let sut = try! CoreDataFeedStore(storeURL: storeURL)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private typealias RetrievalResult = Swift.Result<Data?, Error>
    
    private func notFound() -> RetrievalResult {
        return .success(.none)
    }
    
    private func found(_ data: Data) -> RetrievalResult {
        return .success(data)
    }
    
    private func localItem(url: URL) -> LocalTodoItem {
        let item = uniqueLocalItem()
        return LocalTodoItem(
            id: item.id,
            title: item.title,
            description: item.description,
            completed: item.completed,
            createdAt: item.createdAt,
            dueDate: item.dueDate,
            imageURL: url,
            dependencies: item.dependencies
        )
    }
    
    private func  expect(
        _ sut: CoreDataFeedStore,
        toCompleteRetrievalWith expectedResult: RetrievalResult,
        for url: URL,
        file: StaticString = #file,
        line: UInt = #line) async {
            
            let receivedResult: RetrievalResult
            
            do {
                let data = try await sut.retrieve(from: url)
                receivedResult = .success(data)
            } catch {
                receivedResult = .failure(error)
            }
            
            switch (receivedResult, expectedResult) {
            case let (.success( receivedData), .success(expectedData)):
                XCTAssertEqual(receivedData, expectedData, file: file, line: line)
            default:
                XCTFail("Expected \(expectedResult), got \(receivedResult) instead", file: file, line: line)
                
            }
        }
    
    private func insert(
        _ data: Data,
        for url: URL,
        into sut: CoreDataFeedStore,
        file: StaticString = #filePath,
        line: UInt = #line) async {
            do {
                let image = localItem(url: url)
                try await sut.insert([image])
                try await sut.cache(data, for: url)
            } catch {
                XCTFail("Failed to insert \(data) with error \(error)", file: file, line: line)
            }
        }
}
