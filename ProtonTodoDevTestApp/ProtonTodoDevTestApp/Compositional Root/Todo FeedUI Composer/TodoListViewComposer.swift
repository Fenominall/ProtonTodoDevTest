//
//  ListViewComposer.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

final class TodoListViewComposer {
    private init() {}
    
    private typealias LoadFeedPresentationAdapter = LoadResourcePresentationAdapter<[TodoItem]>
    private typealias ImageDataLoadingPresentationAdapter = LoadResourcePresentationAdapter<Data>
    
    static func composedViewWith(
        title: String,
        feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
        imageLoader: @escaping (URL) -> TodoImageLoader.Publisher,
        todoItemSaveable: TodoItemSaveable,
        tasksFilter: @escaping ([TodoItem]) -> [TodoItem],
        selection: @escaping (TodoItem) -> Void
    ) -> TodoListView {
        let adapter = LoadFeedPresentationAdapter(loader: feedLoader)
        let viewModel = TodoFeedViewModel(
            loadFeed: adapter.load,
            taskFilter: tasksFilter,
            selection: selection
        )
        
        let view = TodoListView(
            navigationTitle: title,
            viewModel: viewModel,
            todoRowView: { createTaskRow(with: $0) }
        )
        
        func createTaskRow(with task: TodoItemPresentationModel) -> TodoRowView {
            let imageLoadingAdapter = ImageDataLoadingPresentationAdapter(loader: { [imageLoader] in
                imageLoader(task.imageURL)
            })
            let viewModel = TaskRowViewModel(
                receivedTask: task,
                loadImageData: imageLoadingAdapter.load,
                taskToUpdate: { task in
                    todoItemSaveable.cachingItem(task.toModel())
                })
            return TodoRowView(viewModel: viewModel)
        }
        
        return view
    }
}

private extension TodoItemSaveable {
    func cachingItem(_ item: TodoItem) {
        Task  {
            try await save(item)
        }
    }
}

private extension TodoItemPresentationModel {
    func toModel() -> TodoItem {
        TodoItem(
            id: id,
            title: title,
            description: description,
            completed: completed,
            createdAt: createdAt,
            dueDate: createdAt,
            imageURL: imageURL,
            dependencies: dependencies
        )
    }
}
