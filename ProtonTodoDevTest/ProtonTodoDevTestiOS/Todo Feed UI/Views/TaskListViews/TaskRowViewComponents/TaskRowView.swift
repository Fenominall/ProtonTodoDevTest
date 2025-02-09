//
//  TaskRowView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

public struct TaskRowView: View {
    @StateObject private var viewModel: TaskRowViewModel
    
    public init(viewModel: TaskRowViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let vSpacing: CGFloat = 5
    private let hSpacing: CGFloat = 5
    private let bottomPadding: CGFloat = 15
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: hSpacing) {
                    TaskRowImageView(imageData: viewModel.task.imageData)
                    
                    VStack(alignment: .leading, spacing: vSpacing) {
                        TaskTitleDescriptionView(
                            title: viewModel.task.title,
                            description: viewModel.task.description
                        )
                        
                        TaskRowInfoVIew(
                            createdAt: viewModel.task.createdAtString,
                            dueDate: viewModel.task.dueDateString)
                    }
                }
                .padding(.bottom, bottomPadding)
                
                TaskRowCompletionToggleView(
                    isCompleted: $viewModel.task.completed,
                    onCompletionStatusChange: { _ in
                    })
            }
        }
        .task {
            await viewModel.loadImageData()
        }
    }
}
