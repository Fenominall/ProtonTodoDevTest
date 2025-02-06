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
            
            if let imageData = viewModel.receivedImageData, !imageData.isEmpty {
                TaskDetailImageView(imageData: imageData)
            }

            VStack(alignment: .leading, spacing: 5) {
                TaskTitleDescriptionView(title: viewModel.title, description: viewModel.description)
                InfoRowView(label: "Created", timestamp: viewModel.createdAt)
                InfoRowView(label: "Due", timestamp: viewModel.dueDate)
            }
            
            Spacer()
            
            // If the image is not downloaded, show the "Download Image" button
            if !viewModel.isImageDownloaded {
                DownloadImageButton(action: viewModel.downloadImage)
            }
        }
        // Center everything within the available space
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
}
