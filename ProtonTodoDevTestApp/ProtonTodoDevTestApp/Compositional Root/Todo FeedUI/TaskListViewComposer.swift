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

final class TaskListViewComposer {
    private init() {}
    
    private typealias LoadFeedPresentationAdapter = LoadResourcePresentationAdapter<[TodoItem]>
    private typealias ImageDataLoadingPresentationAdapter = LoadResourcePresentationAdapter<Data>
    
    static func composedViewWith(
        title: String,
        feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
        imageLoader: @escaping (URL) -> TodoImageLoader.Publisher,
        todoItemSaveable: TodoItemSaveable,
        selection: @escaping (TodoItem) -> Void
    ) -> TaskListView {
        let adapter = LoadFeedPresentationAdapter(loader: feedLoader)
        let viewModel = TodoFeedViewModel(
            loadFeed: adapter.load,
            selection: selection)
        
        let view = TaskListView(
            navigationTitle: title,
            viewModel: viewModel,
            taskRowView: { createTaskRow(with: $0) }
        )
        
        func createTaskRow(with task: TodoItemPresentationModel) -> TaskRowView {
            let imageLoadingAdapter = ImageDataLoadingPresentationAdapter(loader: { [imageLoader] in
                imageLoader(task.imageURL)
            })
            let viewModel = TaskRowViewModel(
                receivedTask: task,
                loadImageData: imageLoadingAdapter.load,
                taskToUpdate: { task in
                    todoItemSaveable.cachingItem(task.toModel())
                })
            return TaskRowView(viewModel: viewModel)
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
            imageURL: imageURL
        )
    }
}
