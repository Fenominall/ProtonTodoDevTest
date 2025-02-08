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
    
    private typealias LoadFeedAdapter = LoadResourcePresentationAdapter<[TodoItem]>
    
    static func composedViewWith(
        title: String,
        feedLoader: @escaping () -> AnyPublisher<[TodoItem], Error>,
        imageLoader: @escaping (URL) -> AnyPublisher<Data, Error>,
        todoItemSaveable: TodoItemSaveable,
        selection: @escaping (TodoItem) -> Void
    ) -> TaskListView {
        let adapter = LoadFeedAdapter(loader: feedLoader)
        let viewModel = TodoFeedViewModel(
            loadFeed: adapter.load,
            selection: selection,
            todoStatusChaged: {
                todoItemSaveable.cachingItem($0)
            }
        )
        
        let view = TaskListView(
            navigationTitle: title,
            viewModel: viewModel
        )
        return view
    }
}

extension TodoItemSaveable {
    func cachingItem(_ item: TodoItem) {
        Task  {
            try await save(item)
        }
    }
}
