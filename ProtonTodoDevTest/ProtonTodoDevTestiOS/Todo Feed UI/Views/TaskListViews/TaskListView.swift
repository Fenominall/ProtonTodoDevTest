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
                        TaskRowView(task: $task)
                    }
                    .listRowSeparator(.hidden)
                }
            }
            .padding(.horizontal, 35)
            .listStyle(.plain)
            .navigationTitle(navigationTitle)
        }
        .refreshable {}
        .task {}
    }
}
