//
//  TaskRowViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/8/25.
//

import Foundation
import ProtonTodoDevTest
import Combine
import SwiftUI

public final class TaskRowViewModel: ObservableObject {
    @Published var publishedTask: TodoItemPresentationModel
    @Binding var bindableTask: TodoItemPresentationModel
    @Published var isImageLoadFail: Bool = false
    private let loadImageData: () async throws -> Data?
    private let taskId: (UUID) async -> Bool
    
    public init(
        receivedTask: Binding<TodoItemPresentationModel>,
        loadImageData: @escaping () async throws -> Data?,
        taskId: @escaping (UUID) async -> Bool
    ) {
        self._bindableTask = receivedTask
        self._publishedTask = .init(initialValue: receivedTask.wrappedValue)
        self.loadImageData = loadImageData
        self.taskId = taskId
    }
    
    @MainActor
    func loadImageData() async {
        do {
            let imageLoadResult = try await loadImageData()
            publishedTask.imageData = imageLoadResult
        } catch {
            isImageLoadFail = true
        }
    }
    
    func updateTodoStatus() async -> Bool {
        let taskIdValue = await MainActor.run { bindableTask.id }
        return await taskId(taskIdValue)
    }
}
