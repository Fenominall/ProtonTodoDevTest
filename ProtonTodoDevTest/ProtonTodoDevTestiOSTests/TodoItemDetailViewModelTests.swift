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
}
