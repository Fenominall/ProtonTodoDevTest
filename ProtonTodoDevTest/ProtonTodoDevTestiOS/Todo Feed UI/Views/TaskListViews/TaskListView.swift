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
    @ObservedObject private var viewModel: TodoFeedViewModel
    
    
    public init(navigationTitle: String, viewModel: TodoFeedViewModel) {
        self.navigationTitle = navigationTitle
        self.viewModel = viewModel
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
                            TaskRowView(
                                task: $task,
                                onCompletionStatusChange: viewModel.updateTodoStatus
                            )
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
