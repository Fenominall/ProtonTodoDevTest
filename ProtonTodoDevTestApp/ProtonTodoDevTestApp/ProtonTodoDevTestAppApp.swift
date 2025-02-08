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
        return AnyView(TaskListViewComposer
            .composedViewWith(
                title: "All Tasks",
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeRemoteFeedImageDataLoaderWithLocalFallback,
                todoItemSaveable: localTodoFeedManager,
                selection: { _ in
                }))
    }
    
    private func makeUpcomingTasksView() -> AnyView {
        return AnyView(TaskListViewComposer
            .composedViewWith(
                title: "Upcoming Tasks",
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeRemoteFeedImageDataLoaderWithLocalFallback,
                todoItemSaveable: localTodoFeedManager, selection: { _ in
                }))
    }
    
    // Trying to load the image data from the local storage if not succes using httpclient to download the files by the url
    private func makeRemoteFeedImageDataLoaderWithLocalFallback(url: URL) -> TodoImageLoader.Publisher {
        let localimageLoader = LocalTodoImageCachingManager(imageStore: store)
        
        return localimageLoader
            .loadImageDataPublisher(from: url)
            .fallback { [httpClient] in
                httpClient
                    .getPublisher(from: url)
                    .tryMap(TodoImageDataMapper.map)
                    .caching(to: localimageLoader, using: url)
                    .subscribe(on: DispatchQueue.main)
                    .eraseToAnyPublisher()
            }
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    private func makeRemoteFeedLoaderWithLocalFallback() -> AnyPublisher<[TodoItem], Error> {
        return makeRemoteFeedLoader()
            .caching(to: localTodoFeedManager)
            .fallback(to: localTodoFeedManager.loadPublisher)
            .subscribe(on: DispatchQueue.main)
            .eraseToAnyPublisher()
        
    }
    
    private func makeRemoteFeedLoader() -> AnyPublisher<[TodoItem], Error> {
        return httpClient
            .getPublisher(from: baseURL)
            .tryMap(TodoFeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
}
