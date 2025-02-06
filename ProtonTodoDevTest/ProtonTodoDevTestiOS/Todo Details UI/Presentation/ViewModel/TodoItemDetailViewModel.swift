//
//  TodoItemDetailViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine

public final class TodoItemDetailViewModel: ObservableObject {
    private let task: TodoItemViewModel
    @Published var receivedImageData: Data?
    @Published var isImageDownloaded: Bool = false
    
    // MARK: - Init
    public init(task: TodoItemViewModel) {
        self.task = task
        receivedImageData = task.imageData
    }
    
    var title: String {
        task.title
    }
    
    var description: String {
        task.description
    }
    
    private var imageData: Data? {
        task.imageData
    }
    
    var createdAt: String {
        task.createdAtString
    }
    
    var dueDate: String {
        task.dueDateString
    }
    
    // MARK: - Helpers
    func downloadImage() {
        // TODO
        isImageDownloaded = true
    }
}
