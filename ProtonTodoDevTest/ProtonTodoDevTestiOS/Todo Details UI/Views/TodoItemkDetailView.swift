//
//  TaskDetailView.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

public struct TodoItemkDetailView: View {
    @ObservedObject private var viewModel: TodoItemDetailViewModel
    
    public init(viewModel: TodoItemDetailViewModel) {
        self.viewModel = viewModel
    }
    
    public var body: some View {
        VStack(alignment: .center) {
            Spacer()
            
            if viewModel.isImageLoading {
                TodoDetailImageView(imageData: viewModel.imageData)
            }
            VStack(alignment: .leading, spacing: 5) {
                TodoTitleDescriptionView(title: viewModel.title, description: viewModel.description)
                InfoRowView(label: "Created", timestamp: viewModel.createdAt)
                InfoRowView(label: "Due", timestamp: viewModel.dueDate)
            }
            
            Spacer()
            
            if !viewModel.isImageLoading {
                TodoDownloadImageButtonView(action: viewModel.downloadImage)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .alert(
            viewModel.imageLoadingError ?? "Network Error",
            isPresented: $viewModel.showImageLoadingError
        ) {
            Button("Retry", role: .cancel) {
                Task {
                    await viewModel.downloadImage()
                }
            }
        }
    }
}
