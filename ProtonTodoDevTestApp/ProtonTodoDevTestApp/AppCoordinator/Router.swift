//
//  AppCoordinator.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/13/25.
//

import SwiftUI
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

final class Router: ObservableObject {
    @Published var navigationPath = NavigationPath()
    private let detailViewFactory: (TodoItem) -> TodoItemkDetailView

    init(detailViewFactory: @escaping (TodoItem) -> TodoItemkDetailView) {
        self.detailViewFactory = detailViewFactory
    }

    func pushDetailView(for item: TodoItem) {
        navigationPath.append(item)
    }

    func goBack() {
        navigationPath.removeLast()
    }

    func goHome() {
        navigationPath.removeLast(navigationPath.count)
    }
}
