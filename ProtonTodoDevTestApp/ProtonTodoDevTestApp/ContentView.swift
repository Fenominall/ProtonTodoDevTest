//
//  ContentView.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import ProtonTodoDevTest
import ProtonTodoDevTestiOS

struct ContentView: View {
    @ObservedObject private var badgeCountViewModel: DashboardViewModel
    private let allTasksView: TodoListView
    private let upcomingTasksView: TodoListView
    
    init(badgeCountViewModel: DashboardViewModel) {
        self.badgeCountViewModel = badgeCountViewModel
        self.allTasksView = badgeCountViewModel.allTasksView
        self.upcomingTasksView = badgeCountViewModel.upComingTasksView
    }
    
    var body: some View {
        Text("Proton Test")
            .font(.largeTitle)
        TabView {
            allTasksView
                .tabItem {
                    Label(
                        "All Tasks",
                        systemImage: AppImageConsntants.house.rawValue
                    )
                }
                .badge(badgeCountViewModel.allTaskViewBadge)
            
            upcomingTasksView
                .tabItem {
                    Label(
                        "Upcoming Tasks",
                        systemImage: AppImageConsntants.calendar.rawValue
                    )
                }
                .badge(badgeCountViewModel.upcomingTasksViewBagde)
        }
    }
}
