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

final class ListViewComposer {
    private init() {}
    
    static func composedViewWith(
        title: String,
        feedLoader: () -> AnyPublisher<[TodoItem], Error>,
        imageLoader: (URL) -> AnyPublisher<Data, Error>,
        selection: (TodoItem) -> Void
    ) -> TaskListView {
        let viewModel = TodoFeedViewModel()
        
        let view = TaskListView(
            navigationTitle: title,
            viewModel: viewModel
        )
        return view
    }
}
