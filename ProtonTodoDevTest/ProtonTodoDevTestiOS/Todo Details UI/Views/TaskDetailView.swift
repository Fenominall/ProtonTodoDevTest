//
//  TaskDetailView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

public struct TaskDetailView: View {
    @ObservedObject private var viewModel: TodoItemDetailViewModel
    
    public init(viewModel: TodoItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if viewModel.isImageDownloaded {
                TaskDetailImageView(imageData: viewModel.receivedImageData)
            }
            VStack(alignment: .leading, spacing: 5) {
                TaskTitleDescriptionView(title: viewModel.title, description: viewModel.description)
                InfoRowView(label: "Created", timestamp: viewModel.createdAt)
                InfoRowView(label: "Due", timestamp: viewModel.dueDate)
            }
            
            Spacer()
            
            if !viewModel.isImageDownloaded {
                DownloadImageButtonView(action: viewModel.downloadImage)
            }
        }
        // Center everything within the available space
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    TaskDetailView(
        viewModel: TodoItemDetailViewModel(
            task: TodoItemPresentationModel(
                id: UUID(),
                title: "A title",
                description: "A description",
                completed: true,
                createdAt: Date.now,
                dueDate: Date.now,
                imageURL: URL(string: "")!,
                imageData: Data()
            )
        )
    )
}
