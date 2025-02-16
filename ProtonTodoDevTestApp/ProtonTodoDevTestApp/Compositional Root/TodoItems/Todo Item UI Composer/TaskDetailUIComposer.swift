//
//  TaskDetailUIComposer.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/9/25.
//

import Foundation
import Combine
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

final class TodoDetailViewComposer {
    private init() {}
    
    private typealias ImageDataLoadingPresentationAdapter = LoadResourcePresentationAdapter<Data>

    static func composedViewWith(
        item: TodoItem,
        imageLoader: @escaping (URL) -> TodoImageLoader.Publisher
    ) -> TodoItemDetailView {
        let imageLoadingAdapter = ImageDataLoadingPresentationAdapter(loader: { [imageLoader] in
            imageLoader(item.imageURL)
        })
        let viewModel = TodoItemDetailViewModel(task: item, imageLoad: imageLoadingAdapter.load)
        let view = TodoItemDetailView(viewModel: viewModel)
        return view
    }
}
