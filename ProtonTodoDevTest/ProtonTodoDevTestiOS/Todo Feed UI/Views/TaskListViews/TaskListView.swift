//
//  TaskListView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import SwiftUI

public struct TaskListView: View {
    private let navigationTitle: String
    @StateObject private var viewModel: TodoFeedViewModel
    public let taskRowView: (TodoItemPresentationModel) -> TaskRowView
    
    public init(
        navigationTitle: String,
        viewModel: TodoFeedViewModel,
        taskRowView: @escaping (TodoItemPresentationModel) -> TaskRowView
    ) {
        self.navigationTitle = navigationTitle
        _viewModel = StateObject(wrappedValue: viewModel)
        self.taskRowView = taskRowView
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
                            taskRowView(task)
                        }
                        
                    }
                    .listRowSeparator(.visible)
                }
            }
            .padding(.horizontal, 35)
            .listStyle(.plain)
            .navigationTitle(navigationTitle)
        }
        .refreshable { viewModel.load() }
        .onAppear{ viewModel.load() }
    }
}
