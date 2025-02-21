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
    
    func test_sortedTasksBy_returnsUnsortedTasksAsSortedTasksByCreationDateInTheDescendingOrderPredicate() {
        let date1 = Date(timeIntervalSince1970: 1000)
        let date2 = Date(timeIntervalSince1970: 0)
        let task1 = uniqueItem(createdAt: date2)
        let task2 = uniqueItem(createdAt: date1)
        
        let unsortedTasks = [task1, task2]
        let sortedTasks = TasksFilteringManager.sortTasksBy(unsortedTasks) { $0.createdAt > $1.createdAt }
        
        XCTAssertEqual(sortedTasks.count, 2)
        XCTAssertEqual(sortedTasks[0].createdAt, date1)
        XCTAssertEqual(sortedTasks[1].createdAt, date2)
    }
}
