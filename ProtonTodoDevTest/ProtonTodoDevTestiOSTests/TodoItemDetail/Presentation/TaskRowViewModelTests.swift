//
//  TaskRowViewModelTests.swift
//  ProtonTodoDevTestiOSTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import Combine
import ProtonTodoDevTest
@testable import ProtonTodoDevTestiOS
import SwiftUI
import XCTest

final class TaskRowViewModelTests: XCTestCase {
    
    // MARK: - Init state
    func test_init_setsCorrectlyInitialValues() {
        let anyTaskDTO = anyPresentationModel()
        
        let sut = makeSUT(task: anyTaskDTO)
        
        XCTAssertEqual(sut.bindableTask, anyTaskDTO)
        XCTAssertEqual(sut.publishedTask, anyTaskDTO)
        XCTAssertFalse(sut.isImageLoadFail)
    }
    
    // MARK: - Image Loading
    func test_loadImageData_setsImageDataForPublishedTaskImageDataOnSuccessfullImageLoad() async {
        let anyTaskDTO = anyPresentationModel()
        let anyData = anyData()
        let sut = makeSUT(task: anyTaskDTO, imageLoad: { anyData })
        
        await sut.loadImageData()
        
        XCTAssertEqual(sut.publishedTask.imageData, anyData)
        XCTAssertFalse(sut.isImageLoadFail)
    }
    
    func test_loadImageData_setsIsImageLoadFailFlagToTrueAndKeepsImageDataNilOnImageLoadFailure() async {
        let anyTaskDTO = anyPresentationModel()
        let loadDataError = anyNSError()
        let sut = makeSUT(task: anyTaskDTO, imageLoad: {
            throw loadDataError
        })
        
        await sut.loadImageData()
        
        XCTAssertNil(sut.publishedTask.imageData)
        XCTAssertTrue(sut.isImageLoadFail)
    }
    
    // MARK: - Update Todo Status
    func test_updateTodoStatus_returnFalseIfTodoStatusCannotBeToggled() async {
        let sut = makeSUT(taskID:  { _ in
            return false
        })
        
        let result = await sut.updateTodoStatus()
        
        XCTAssertFalse(result)
    }
    
    func test_updateTodoStatus_returnTrueIfTodoStatusCanBeToggled() async {
        let sut = makeSUT(taskID:  { _ in
            return true
        })
        
        let result = await sut.updateTodoStatus()
        
        XCTAssertTrue(result)
    }

    // MARK: - Helpers
    private func makeSUT(
        task: TodoItemPresentationModel = anyPresentationModel(),
        imageLoad: @escaping () async throws -> Data? = {
            Data()
        },
        taskID: @escaping (UUID) async -> Bool = {
            _ in true
        },
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> TaskRowViewModel {
        
        var localTask = task
        let bindingtask = Binding<TodoItemPresentationModel>(
            get: { localTask },
            set: { localTask = $0 }
        )
        
        let sut = TaskRowViewModel(
            receivedTask: bindingtask,
            loadImageData: imageLoad,
            taskId: taskID
        )
        trackForMemoryLeaks(
            sut,
            file: file,
            line: line
        )
        return sut
    }
}
