//
//  TasksFilteringManagerTests.swift
//  ProtonTodoDevTestAppTests
//
//  Created by Fenominall on 2/21/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest
@testable import ProtonTodoDevTestApp

final class TasksFilteringManagerTests: XCTestCase {
    
    
    // MARK: - Helpers
    private func makeSUT(
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TasksFilteringManager {
        let sut = TasksFilteringManager()
        trackForMemoryLeaks(sut)
        return sut
    }
}
