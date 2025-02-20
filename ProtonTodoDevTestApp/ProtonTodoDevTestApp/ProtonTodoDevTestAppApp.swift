//
//  ProtonTodoDevTestAppApp.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import SwiftUI
import ProtonTodoDevTest
import ProtonTodoDevTestiOS
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
        
    private let localTodoFeedManager: LocalTodoFeedManager
    private let baseURL = URL(string: "https://images.ctfassets.net")!
    
    // MARK: - Init
    init() {
        self.localTodoFeedManager = LocalTodoFeedManager(store: store)
    }
    
    var body: some Scene {
        WindowGroup {
            AppTabView(
                feedLoader: makeRemoteFeedLoaderWithLocalFallback,
                imageLoader: makeRemoteImageDataLoaderWithLocalFallback,
                todoItemSaveable: localTodoFeedManager
            )
        }
    }
    
    // MARK: - Helpers
    // Trying to load the image data from the local storage if not succes using httpclient to download the files by the url
    private func makeRemoteImageDataLoaderWithLocalFallback(url: URL) -> TodoImageLoader.Publisher {
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
        return httpClient
            .getPublisher(from: baseURL)
            .tryMap(TodoFeedItemsMapper.map)
            .eraseToAnyPublisher()
    }
}
