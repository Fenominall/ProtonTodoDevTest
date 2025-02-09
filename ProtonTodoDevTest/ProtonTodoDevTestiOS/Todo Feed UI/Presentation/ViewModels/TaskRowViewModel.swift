//
//  TaskRowViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/8/25.
//

import Foundation
import ProtonTodoDevTest
import Combine

public final class TaskRowViewModel: ObservableObject {
    @Published var publishedTask: TodoItemPresentationModel
    private var receivedTask: TodoItemPresentationModel
    private let loadImageData: () async throws -> Data?
    private let taskToUpdate: (TodoItemPresentationModel) -> Void
    
    public init(
        receivedTask: TodoItemPresentationModel,
        loadImageData: @escaping () async throws -> Data?,
        taskToUpdate: @escaping (TodoItemPresentationModel) -> Void
    ) {
        self.publishedTask = receivedTask
        self.receivedTask = receivedTask
        self.loadImageData = loadImageData
        self.taskToUpdate = taskToUpdate
    }
    
    func loadImageData() async {
        do {
            let imageLoadResult = try await loadImageData()
            await MainActor.run {
                self.publishedTask.imageData = imageLoadResult
            }
        } catch {
            // TODO
        }
    }
    
    func updateTodoStatus(isCompleted status: Bool) async {
        Task {
            receivedTask.completed = status
            taskToUpdate(receivedTask)
        }
    }
}
