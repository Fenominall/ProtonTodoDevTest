//
//  ProtonTodoDevTestAppApp.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import ProtonTodoDevTest

@main
struct ProtonTodoDevTestAppApp: App {
    
    private let httpClient: HTTPClient = {
        URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral))
    }()
    
    private let store: TodoFeedStore = {
        do {
            return try CoreDataFeedStore(storeURL: CoreDataFeedStore.storeURL)
        } catch {
            assertionFailure("Failed to instantiate CoreDataFeedStore with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                allTasksView: AnyView(EmptyView()),
                upcomingTasksView: AnyView(EmptyView())
            )
        }
    }
}
