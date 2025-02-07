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
        selection: @escaping (TodoItem) -> Void
    ) -> TaskListView {
        let adapter = LoadFeedAdapter(loader: feedLoader)
        let viewModel = TodoFeedViewModel(loadFeed: adapter.load, selection: selection)
        
        let view = TaskListView(
            navigationTitle: title,
            viewModel: viewModel
        )
        return view
    }
}
