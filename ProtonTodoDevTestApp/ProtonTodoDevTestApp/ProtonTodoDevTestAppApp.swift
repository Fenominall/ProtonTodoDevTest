//
//  ProtonTodoDevTestAppApp.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI

@main
struct ProtonTodoDevTestAppApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(
                allTasksView: AnyView(EmptyView()),
                upcomingTasksView: AnyView(EmptyView())
            )
        }
    }
}
