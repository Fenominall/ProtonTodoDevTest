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
    
    // MARK: - Sort Tasks By
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
    
    // MARK: - Filter Upcoming Tasks By Dependencies
    func test_filterUpcomingTasksByDependencies_returnEmptyArrayForEmptyInput() {
        let emptyOutput = TasksFilteringManager.filterUpcomingTasksByDependencies([])
        XCTAssertEqual(emptyOutput, [])
    }
    
    func test_filterUpcomingTasksByDependencies_returnEmptyForAllCompletedTasks() {
        let item1 = uniqueItem(completed: true)
        let item2 = uniqueItem(completed: true)
        
        let input = [item1, item2]
        
        let result = TasksFilteringManager.filterUpcomingTasksByDependencies(input)
        XCTAssertEqual(result, [])
    }

    func test_filterUpcomingTasksByDependencies_ordersTasksByDependencies_reverseInput() {
        let depID = UUID()
        let depTask = uniqueItem(id: depID, completed: false)
        let mainTask = uniqueItem(completed: false, dependencies: [depID])
        let input = [depTask, mainTask]
        
        let result = TasksFilteringManager.filterUpcomingTasksByDependencies(input)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].id, depTask.id)
        XCTAssertEqual(result[1].id, mainTask.id)
    }

    func test_filterUpcomingTasksByDependencies_handlesNoDependencies() {
        let task1 = uniqueItem(completed: false)
        let task2 = uniqueItem(completed: false)
        let input = [task1, task2]
        
        let result = TasksFilteringManager.filterUpcomingTasksByDependencies(input)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertTrue(result.contains(where: { $0.id == task1.id }))
        XCTAssertTrue(result.contains(where: { $0.id == task2.id }))
    }
    
    func test_filterUpcomingTasksByDependencies_returnsIncompleteTasksWithNoDependencies() {
        let task1 = uniqueItem(completed: false)
        let task2 = uniqueItem(completed: true)
        let task3 = uniqueItem(completed: false)
        
        let input = [task1, task2, task3]
        let result = TasksFilteringManager.filterUpcomingTasksByDependencies(input)
        
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result, [task1, task3])
    }
}
