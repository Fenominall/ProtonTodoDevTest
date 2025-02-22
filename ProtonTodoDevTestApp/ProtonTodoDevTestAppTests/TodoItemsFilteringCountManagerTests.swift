//
//  TodoItemsFilteringCountManagerTests.swift
//  ProtonTodoDevTestAppTests
//
//  Created by Fenominall on 2/21/25.
//

import Foundation
import Combine
import XCTest
import ProtonTodoDevTest
@testable import ProtonTodoDevTestApp

final class TodoItemsFilteringCountManagerTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    // MARK: - Filter All Tasks
    func test_filterAllTaksAndUpdateAllTasksCount_keepsCountPropertiesZeroAndreturnEmptyArrayOfTasksOnEmptyInput() {
        let sut = makeSUT()
        
        let reuslt = sut.filterAllTaksAndUpdateAllTasksCount([])
        
        XCTAssertEqual(reuslt, [])
        XCTAssertEqual(sut.allTasksCount, 0)
        XCTAssertEqual(sut.upcomingTasksCount, 0)
    }
    
    func test_filterAllTasks_updatesAllTasksCountAndReturnsSortedTasks() async throws {
        let sut = makeSUT()
        let task1 = uniqueItem(createdAt: Date(timeIntervalSince1970: 1000))
        let task2 = uniqueItem(createdAt: Date(timeIntervalSince1970: 0))
        let input = [task2, task1]
        
        let exp = expectation(description: "Wait for allTasksCount update")
        var receivedCounts: [Int] = []
        sut.$allTasksCount
            .dropFirst()
            .sink { count in
                receivedCounts.append(count)
                exp.fulfill()
            }
            .store(in: &cancellables)
        
        let result = sut.filterAllTaksAndUpdateAllTasksCount(input)
        await fulfillment(of: [exp], timeout: 1.0)
        
        XCTAssertEqual(receivedCounts, [2], "Expected count to update to 2")
        XCTAssertEqual(result.count, 2)
        XCTAssertEqual(result[0].createdAt, task1.createdAt)
        XCTAssertEqual(result[1].createdAt, task2.createdAt)
    }

    // MARK: - filterUpcomingTaksAndUpdateupcomingTasksCount
    func test_filterUpcomingTaksAndUpdateupcomingTasksCount_keepsCountPropertiesZeroandreturnEmptyArrayOfTasksOnEptyInput() {
        let sut = makeSUT()
        
        let reuslt = sut.filterAllTaksAndUpdateAllTasksCount([])
        
        XCTAssertEqual(reuslt, [])
        XCTAssertEqual(sut.allTasksCount, 0)
        XCTAssertEqual(sut.upcomingTasksCount, 0)
    }
    
    // MARK: -  Helpers
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> TodoItemsFilteringCountManager {
        let sut = TodoItemsFilteringCountManager()
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
}
