//
//  TaskRowView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

public struct TodoRowView: View {
    @StateObject private var viewModel: TaskRowViewModel
    
    public init(viewModel: TaskRowViewModel) {
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    private let vSpacing: CGFloat = 5
    private let hSpacing: CGFloat = 5
    private let bottomPadding: CGFloat = 15
    
    public var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .top, spacing: hSpacing) {
                    TodoRowImageView(
                        imageData: viewModel.publishedTask.imageData,
                        isImageLoadFail: $viewModel.isImageLoadFail,
                        onRefresh: viewModel.loadImageData
                    )
                    
                    VStack(alignment: .leading, spacing: vSpacing) {
                        TodoTitleDescriptionView(
                            title: viewModel.publishedTask.title,
                            description: viewModel.publishedTask.description
                        )
                        
                        TodoRowInfoVIew(
                            createdAt: viewModel.publishedTask.createdAtString,
                            dueDate: viewModel.publishedTask.dueDateString)
                    }
                }
                .padding(.bottom, bottomPadding)
                
                TodoRowCompletionToggleView(
                    isCompleted: $viewModel.bindableTask.completed,
                    onToggle: viewModel.updateTodoStatus
                )
            }
        }
        .task {
            await viewModel.loadImageData()
        }
    }
}
