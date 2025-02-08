//
//  TodoFeedViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest

public final class TodoFeedViewModel: ObservableObject {
    // MARK: - Properties
    @Published var tasks = [TodoItemPresentationModel]()
    @Published var isLoading: Bool = false
    @Published var error: String?
    
    private let loadFeed: () async throws -> [TodoItem]
    private let selection: (TodoItem) -> Void
    
    private var originalItems = ThreadSafeArray<TodoItem>()
    private var originalItemsDictionary = ThreadSafeDictionary<UUID, Int>()
    
    public init(loadFeed: @escaping () async throws -> [TodoItem],
                selection: @escaping (TodoItem) -> Void
    ) {
        self.loadFeed = loadFeed
        self.selection = selection
    }
    
    func load() {
        guard !isLoading else {
            return }
        
        isLoading = true
        // Task Captures self Weakly by Default in SwiftUI
        // When you create a Task inside an ObservableObject, it doesn’t strongly retain self.
        Task {
            do {
                let items = try await loadFeed()
                await MainActor.run {
                    addOrUpdateTasks(items)
                    self.tasks = items.mapToViewModel()
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.error = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
    
    private func addOrUpdateTasks(_ tasks: [TodoItem]) {
        for task in tasks where originalItemsDictionary[task.id] == nil {
            let currentCount = originalItems.count
            originalItems.append(task)
            originalItemsDictionary[task.id] = currentCount
        }
        
        for task in tasks {
            if let index = originalItemsDictionary[task.id] {
                originalItems.update(at: index, with: task)
            }
        }
    }
    
    func selectItem(with id: UUID) {
        if let index = originalItemsDictionary[id],
           let item = originalItems.get(at: index) {
            selection(item)
        }
    }
}

extension Array where Element == TodoItem {
    func mapToViewRepresentationModel() -> [TodoItemPresentationModel] {
        return map {
            TodoItemPresentationModel(from: $0)
        }
    }
}
