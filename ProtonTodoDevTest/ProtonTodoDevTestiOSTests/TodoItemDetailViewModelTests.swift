//
//  TodoItemDetailViewModelTests.swift
//  ProtonTodoDevTestiOSTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import Combine
import XCTest
import ProtonTodoDevTest
@testable import ProtonTodoDevTestiOS

final class TodoItemDetailViewModelTests: XCTestCase {
    private var cancelables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancelables.removeAll()
        super.tearDown()
    }
    
    func test_init_setsCorrectInitialValues() {
        let item = uniqueItem(
            title: "Custom Title",
            description: "Custom Description",
            createdAt: Date(timeIntervalSince1970: 0),
            dueDate: Date(timeIntervalSince1970: 86400)
        )
        
        let sut = makeSUT(task: item)
        
        XCTAssertEqual(sut.title, item.title)
        XCTAssertEqual(sut.description, item.description)
        XCTAssertEqual(sut.createdAt, item.createdAt.iso8601FormattedString())
        XCTAssertEqual(sut.dueDate, item.dueDate.iso8601FormattedString())
        XCTAssertNil(sut.imageData)
        XCTAssertFalse(sut.isImageLoading)
        XCTAssertFalse(sut.showImageLoadingError)
        XCTAssertNil(sut.imageLoadingError)
    }
    
    func test_downloadImage_successfullySetsImageDataOnNonNilData() async throws {
        let anyData = anyData()
        let sut = makeSUT { anyData }
        
        try await expect(sut, toCompleteWith: .success(anyData))
    }
    
    func test_downloadImage_setsErrorOnImageLoadingFailure() async throws {
        let error = anyNSError()
        let sut = makeSUT { throw error }
        
        try await expect(sut, toCompleteWith: .failure(error))
    }
    
    // MARK: - Helpers
    private func makeSUT(
        task: TodoItem = uniqueItem(),
        imageLoad: @escaping () async throws -> Data? = {
            Data()
        },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TodoItemDetailViewModel {
        let sut = TodoItemDetailViewModel(
            task: task,
            imageLoad: imageLoad
        )
        trackForMemoryLeaks(
            sut,
            file: file,
            line: line
        )
        return sut
    }
    
    private func expect(
        _ sut: TodoItemDetailViewModel,
        toCompleteWith expectedResult: Result<Data?, Error>,
        file: StaticString = #file,
        line: UInt = #line) async throws {
            
            let exp = expectation(description: "Wait for image load")
            
            var receivedImageData: Data?
            var receivedImageLoadingError: String?
            var receivedLoadingStates: [Bool] = []
            
            sut.$imageData
                .dropFirst()
                .sink {
                    receivedImageData = $0
                }
                .store(in: &cancelables)
            
            sut.$imageLoadingError
                .dropFirst()
                .sink {
                    receivedImageLoadingError = $0
                }
                .store(in: &cancelables)
            
            sut.$isImageLoading
                .dropFirst()
                .sink { isLoading in
                    receivedLoadingStates.append(isLoading)
                    if receivedLoadingStates.contains(true) && !isLoading {
                        exp.fulfill()
                    }
                }
                .store(in: &cancelables)
            
            await sut.downloadImage()
            await fulfillment(of: [exp], timeout: 1.0)
            
            switch expectedResult {
            case .success(let expectedData):
                XCTAssertEqual(receivedImageData, expectedData, "Expected imageData \(String(describing: expectedData)), got \(String(describing: receivedImageData))", file: file, line: line)
                XCTAssertFalse(sut.isImageLoading, "Expected isImageLoading to be false", file: file, line: line)
                XCTAssertNil(receivedImageLoadingError, "Expected no error", file: file, line: line)
                XCTAssertFalse(sut.showImageLoadingError, "Expected showImageLoadingError to be false", file: file, line: line)
                XCTAssertEqual(receivedLoadingStates, [true, false], "Expected loading states [true, false]", file: file, line: line)
                
            case .failure:
                XCTAssertNil(receivedImageData, "Expected no imageData on failure", file: file, line: line)
                XCTAssertFalse(sut.isImageLoading, "Expected isImageLoading to be false", file: file, line: line)
                XCTAssertEqual(receivedImageLoadingError, "Network Loading Error...", "Expected error message", file: file, line: line)
                XCTAssertTrue(sut.showImageLoadingError, "Expected showImageLoadingError to be true", file: file, line: line)
                XCTAssertEqual(receivedLoadingStates, [true ,false], "Expected loading states [true, false]", file: file, line: line)
            }
        }
}
