//
//  TodoItemDetailViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

public final class TodoItemDetailViewModel: ObservableObject {
    private let task: TodoItem
    private let imageLoad: () async throws -> Data?
    
    @Published var imageData: Data?
    @Published var isImageLoading: Bool = false
    @Published var imageLoadingError: String?
    @Published var showImageLoadingError: Bool = false
    // MARK: - Init
    public init(task: TodoItem,
                imageLoad: @escaping () async throws -> Data?
    ) {
        self.task = task
        self.imageLoad = imageLoad
    }
    
    // MARK: - Helpers
    var title: String {
        task.title
    }
    
    var description: String {
        task.description
    }
    
    var createdAt: String {
        task.createdAt.iso8601FormattedString(from: task.createdAt)
    }
    
    var dueDate: String {
        task.dueDate.iso8601FormattedString(from: task.dueDate)
    }
    
    // MARK: - Actions
    func downloadImage() async {
        guard !isImageLoading else { return }
        
        isImageLoading = true
        
        Task {
            do {
                let imageData = try await imageLoad()
                await MainActor.run {
                    self.isImageLoading = false
                    self.imageData = imageData
                }
            } catch {
                await MainActor.run {
                    self.isImageLoading = false
                    self.imageLoadingError = "Network Loading Error..."
                    self.showImageLoadingError = true
                }
            }
        }
    }
}
