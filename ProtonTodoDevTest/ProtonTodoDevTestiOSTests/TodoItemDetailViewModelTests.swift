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
