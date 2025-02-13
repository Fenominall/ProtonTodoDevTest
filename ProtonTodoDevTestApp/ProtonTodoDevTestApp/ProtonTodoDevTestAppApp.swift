//
//  ProtonTodoDevTestAppApp.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import ProtonTodoDevTest
import Combine

@main
struct ProtonTodoDevTestAppApp: App {
    
    private let httpClient: HTTPClient = {
        URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral))
    }()
    
    private let scheduler: DispatchQueue = {
        return DispatchQueue(label: "com.fenominall.infra.queue",
                             qos: .userInitiated,
                             attributes: .concurrent)
    }()
    
    private let mockHttpClient: HTTPClient = {
        let mockData = Data(mockJSONString.utf8)
        return MockHTTPClient(data: mockData, statusCode: 200)
    }()
    
    private let store: TodoFeedStore & TodoFeedImageStore = {
        do {
            return try CoreDataFeedStore(storeURL: CoreDataFeedStore.storeURL)
        } catch {
            assertionFailure("Failed to instantiate CoreDataFeedStore with error: \(error.localizedDescription)")
            return NullStore()
        }
    }()
    
    private let baseURL = URL(string: "https:/any.com/")!
    
    private let localTodoFeedManager: LocalTodoFeedManager
    
    // MARK: - Init
    init() {
        self.localTodoFeedManager = LocalTodoFeedManager(store: store)
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(
                allTasksView: makeAllTasksView(),
                upcomingTasksView: makeUpcomingTasksView()
            )
        }
    }
    
    // MARK: - Helpers
    private func makeAllTasksView() -> AnyView {
        return AnyView(TodoListViewComposer
            .composedViewWith(
                title: "All Tasks",
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeRemoteFeedImageDataLoaderWithLocalFallback,
                todoItemSaveable: localTodoFeedManager,
                tasksFilter: { tasks in
                    sortTasksAndFilterByPredicate(tasks) { $0.createdAt > $1.createdAt }
                },
                selection: { _ in }))
    }
    
    private func sortTasksAndFilterByPredicate(
        _ items: [TodoItem],
        by preicate: (TodoItem, TodoItem) -> Bool
    ) -> [TodoItem] {
        return items.sorted(by: preicate)
    }
    
    private func makeUpcomingTasksView() -> AnyView {
        return AnyView(TodoListViewComposer
            .composedViewWith(
                title: "Upcoming Tasks",
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeRemoteFeedImageDataLoaderWithLocalFallback,
                todoItemSaveable: localTodoFeedManager,
                tasksFilter: filterUpcomingTasksByDependencies,
                selection: { _ in }))
    }
    
    private func filterUpcomingTasksByDependencies(_ items: [TodoItem]) -> [TodoItem] {
        var filteredItems: [TodoItem] = []
        
        for item in items {
            if !item.completed {
                filteredItems.append(item)
            }
        }
        
        var graph: [UUID: [UUID]] = [:]
        var taskMap: [UUID: TodoItem] = [:]
        var visiting: Set<UUID> = []
        var visited: Set<UUID> = []
        var resultStack = [TodoItem]()
        
        for todo in filteredItems {
            graph[todo.id] = todo.dependencies
            taskMap[todo.id] = todo
        }
        
        func dfs(_ taskID: UUID) -> Bool {
            if visiting.contains(taskID) { return false }
            if visited.contains(taskID) { return true }
            
            visiting.insert(taskID)
            
            for depID in graph[taskID] ?? [] {
                if !dfs(depID) { return false }
            }
            
            visiting.remove(taskID)
            visited.insert(taskID)
            
            if let task = taskMap[taskID] {
                resultStack.append(task)
            }
            
            return true
        }
        
        for taskID in filteredItems {
            if !visited.contains(taskID.id) {
                if !dfs(taskID.id) {
                    return []
                }
            }
        }
        
        return resultStack
    }
    
    private func makeTodoTedailView(for item: TodoItem) -> AnyView {
        return AnyView(
            TodoDetailViewComposer.composedViewWith(
                item: item,
                imageLoader: makeRemoteFeedImageDataLoaderWithLocalFallback)
        )
    }
    
    // Trying to load the image data from the local storage if not succes using httpclient to download the files by the url
    private func makeRemoteFeedImageDataLoaderWithLocalFallback(url: URL) -> TodoImageLoader.Publisher {
        let localimageLoader = LocalTodoImageCachingManager(imageStore: store)
        return localimageLoader
            .loadImageDataPublisher(from: url)
            .fallback { [httpClient, scheduler] in
                httpClient
                    .getPublisher(from: url)
                    .tryMap(TodoImageDataMapper.map)
                    .caching(to: localimageLoader, using: url)
                    .subscribe(on: scheduler)
                    .eraseToAnyPublisher()
            }
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[TodoItem], Error> {
        return makeRemoteFeedLoader()
            .caching(to: localTodoFeedManager)
            .fallback(to: localTodoFeedManager.loadPublisher)
            .subscribe(on: scheduler)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoader() -> AnyPublisher<[TodoItem], Error> {
        return mockHttpClient
            .getPublisher(from: baseURL)
            .tryMap(TodoFeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
}
