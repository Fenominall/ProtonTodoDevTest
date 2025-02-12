//
//  TaskListView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import SwiftUI

public struct TodoListView: View {
    private let navigationTitle: String
    @StateObject private var viewModel: TodoFeedViewModel
    public let todoRowView: (Binding<TodoItemPresentationModel>) -> TodoRowView
    
    @State private var error: String?
    private var isShowingError: Binding<Bool> {
        Binding {
            error != nil
        } set: { _ in
            error = nil
        }
    }
    
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
            .alertView(
                isShowingError: isShowingError,
                title: "Loading Network Error",
                buttonTitle: "Retry",
                message: viewModel.error,
                action: viewModel.load
            )
        }
        .refreshable { viewModel.load() }
        .onAppear{ viewModel.load() }
        .onChange(of: viewModel.error) { _, newValue in
            error = newValue
        }
    }
}
