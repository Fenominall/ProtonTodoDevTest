//
//  ListViewComposer.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import SwiftUI
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
        print("CREATED TodoListViewComposer")
        print("TodoListViewComposer INIT - ObjectIdentifier: \(ObjectIdentifier(self).hashValue)")
        let adapter = LoadFeedPresentationAdapter(loader: feedLoader)
        let feedViewModel = TodoFeedViewModel(
            loadFeed: adapter.load,
            taskFilter: tasksFilter,
            selection: selection,
            taskToUpdate: todoItemSaveable.cachingItem)
        
        let view = TodoListView(
            navigationTitle: title,
            viewModel: feedViewModel,
            todoRowView: { createTaskRow(with: $0) }
        )
        
        func createTaskRow(with task: Binding<TodoItemPresentationModel>) -> TodoRowView {
            let imageURL = task.wrappedValue.imageURL

            let imageLoadingAdapter = ImageDataLoadingPresentationAdapter(loader: { [imageLoader] in
                imageLoader(imageURL)
            })
            let viewModel = TaskRowViewModel(
                receivedTask: task,
                loadImageData: imageLoadingAdapter.load,
                taskId: feedViewModel.toggleTaskCompletion)
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
