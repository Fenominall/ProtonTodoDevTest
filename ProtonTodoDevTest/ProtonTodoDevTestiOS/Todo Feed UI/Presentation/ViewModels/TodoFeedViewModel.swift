//
//  TodoFeedViewModel.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine

public final class TodoFeedViewModel: ObservableObject {
    @Published var tasks = [TodoItemViewModel]()
    @Published var isLoading: Bool = false
    @Published var error: String?
}
