//
//  ContentView.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import ProtonTodoDevTestiOS

struct ContentView: View {
    private let allTasksView: AnyView
    private let upcomingTasksView: AnyView
    
    init(allTasksView: AnyView, upcomingTasksView: AnyView) {
        self.allTasksView = allTasksView
        self.upcomingTasksView = upcomingTasksView
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
            
            upcomingTasksView
                .tabItem {
                    Label(
                        "Upcoming Tasks",
                        systemImage: AppImageConsntants.calendar.rawValue
                    )
                }
        }
    }
}

#Preview {
    ContentView(allTasksView: AnyView(EmptyView()), upcomingTasksView: AnyView(EmptyView()))
}
