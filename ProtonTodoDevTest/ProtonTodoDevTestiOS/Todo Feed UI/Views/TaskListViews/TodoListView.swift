//
//  TaskListView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import SwiftUI
import Combine

public struct TodoListView: View {
    private let navigationTitle: String
    @StateObject private var viewModel: TodoFeedViewModel
    public let todoRowView: (Binding<TodoItemPresentationModel>) -> TodoRowView
    
    public let taskCountPublisher: AnyPublisher<Int, Never>
    
    public init(
        navigationTitle: String,
        viewModel: TodoFeedViewModel,
        todoRowView: @escaping (Binding<TodoItemPresentationModel>) -> TodoRowView
    ) {
        self.navigationTitle = navigationTitle
        _viewModel = StateObject(wrappedValue: viewModel)
        self.todoRowView = todoRowView
        
        taskCountPublisher = viewModel.$tasks
            .map { $0.count }
            .eraseToAnyPublisher()
    }
    
    public var body: some View {
        NavigationStack {
            List {
                ForEach($viewModel.tasks) { $task in
                    NavigationLink {
                        
                    } label: {
                        Button {
                            Task {
                                await viewModel.selectItem(with: task.id)
                            }
                        } label: {
                            todoRowView($task)
                        }
                        
                    }
                    .listRowSeparator(.visible)
                }
            }
            .padding(.horizontal, 35)
            .listStyle(.plain)
            .navigationTitle(navigationTitle)
            .todoFeedErrorAlert(
                error: $viewModel.todoFeedError,
                retryAction:viewModel.load)
        }
        .refreshable { viewModel.load() }
        .onAppear{ viewModel.load() }
    }
}
