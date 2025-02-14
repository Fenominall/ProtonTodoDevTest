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
        
    public init(
        navigationTitle: String,
        viewModel: TodoFeedViewModel,
        todoRowView: @escaping (Binding<TodoItemPresentationModel>) -> TodoRowView
    ) {
        self.navigationTitle = navigationTitle
        _viewModel = StateObject(wrappedValue: viewModel)
        self.todoRowView = todoRowView
    }
    
    public var body: some View {
        List {
            ForEach($viewModel.tasks) { $task in
                Button {
                    Task {
                        await viewModel.selectItem(with: task.id)
                    }
                } label: {
                    todoRowView($task)
                }
            }
        }
        .listRowSeparator(.visible)
        .padding(.horizontal, 35)
        .listStyle(.plain)
        .navigationTitle(navigationTitle)
        .todoFeedErrorAlert(
            error: $viewModel.todoFeedError,
            retryAction:viewModel.load)
        .refreshable { viewModel.load() }
        .onAppear{ viewModel.load() }
    }
}
