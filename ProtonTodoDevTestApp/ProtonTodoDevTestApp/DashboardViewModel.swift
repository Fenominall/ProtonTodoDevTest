//
//  BadgeCountViewModel.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/13/25.
//

import Foundation
import SwiftUI
import ProtonTodoDevTest
import ProtonTodoDevTestiOS
import Combine

final class DashboardViewModel: ObservableObject {
    @Published var allTaskViewBadge: Int = 0
    @Published var upcomingTasksViewBagde: Int = 0
    
    let allTasksView: TodoListView
    let upComingTasksView: TodoListView
    
    private var cancelables: Set<AnyCancellable> = []
    
    init(allTasksView: TodoListView, upComingTasksView: TodoListView) {
        self.allTasksView = allTasksView
        self.upComingTasksView = upComingTasksView
        
        setupCountPublishers()
    }
    
    private func setupCountPublishers() {
        allTasksView.taskCountPublisher
            .sink { [weak self] count in
                self?.allTaskViewBadge = count
            }
            .store(in: &cancelables)
        
        upComingTasksView.taskCountPublisher
            .sink { [weak self] count in
                self?.upcomingTasksViewBagde = count
            }
            .store(in: &cancelables)
    }
}
