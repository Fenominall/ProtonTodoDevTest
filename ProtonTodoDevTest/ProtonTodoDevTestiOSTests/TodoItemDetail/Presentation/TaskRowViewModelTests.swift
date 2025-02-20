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
    
    func test_init_setsCorrectlyInitialValues() {
        let anyTaskDTO = anyPresentationModel()
        
        let sut = makeSUT(task: anyTaskDTO)
        
        XCTAssertEqual(sut.bindableTask, anyTaskDTO)
        XCTAssertEqual(sut.publishedTask, anyTaskDTO)
        XCTAssertFalse(sut.isImageLoadFail)
    }
    
    func test_loadImageData_setsImageDataForPublishedTaskImageDataOnSuccessfullImageLoad() async {
        let anyTaskDTO = anyPresentationModel()
        let anyData = anyData()
        let sut = makeSUT(task: anyTaskDTO, imageLoad: { anyData })
        
        await sut.loadImageData()
        
        XCTAssertEqual(sut.publishedTask.imageData, anyData)
        XCTAssertFalse(sut.isImageLoadFail)
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
