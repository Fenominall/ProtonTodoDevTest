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
    @Published var task: TodoItemPresentationModel
    private let loadImageData: () async throws -> Data?
    
    public init(
        task: TodoItemPresentationModel,
        loadImageData: @escaping () async throws -> Data?
    ) {
        self.task = task
        self.loadImageData = loadImageData
    }
    
    func loadImageData() async {
        do {
            let imageLoadResult = try await loadImageData()
            await MainActor.run {
                self.task.imageData = imageLoadResult
            }
        } catch {
            // TODO
        }
    }
    
    func updateTodoStatus(isCompleted status: Bool) async {
        // TODO
        task.completed = status
    }
}
