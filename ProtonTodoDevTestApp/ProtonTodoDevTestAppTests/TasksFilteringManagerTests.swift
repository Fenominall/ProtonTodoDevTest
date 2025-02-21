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
    
    func test_sortTasksBy_returnsEmptyArrayForEmptyInput() {
        let emptySortedTasks = TasksFilteringManager.sortTasksBy([]) { $0.createdAt > $1.createdAt }
        XCTAssertEqual(emptySortedTasks, [])
    }
    
    func test_sortedTasksBy_returnsSingleTaskUnchanged() {
        let anyTask = uniqueItem()
        let emptySortedTasks = TasksFilteringManager.sortTasksBy([anyTask]) { $0.createdAt > $1.createdAt }
        XCTAssertEqual(emptySortedTasks, [anyTask])
    }
}
