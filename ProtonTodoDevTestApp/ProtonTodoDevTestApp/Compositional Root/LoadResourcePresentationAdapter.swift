//
//  LoadResourcePresentationAdapter.swift
//  ProtonTodoDevTestApp
//
//  Created by Fenominall on 2/6/25.
//

import Foundation
import Combine

final class LoadResourcePresentationAdapter<Resource> {
    private let loader: () -> AnyPublisher<Resource, Error>
    
    private var cancelable: Cancellable?
    private var isLoading = false
    
    init(loader: @escaping () -> AnyPublisher<Resource, Error>) {
        self.loader = loader
    }
    
    func load() async throws -> Resource {
        return try await withCheckedThrowingContinuation { [weak self] continuaion in
            guard let self else { return }
            guard !isLoading else { return }
            
            isLoading = true
            
            cancelable = loader()
                .receive(on: DispatchQueue.main)
                .handleEvents(receiveCancel: { [weak self] in
                    self?.finishLoading()
                })
                .sink(
                    receiveCompletion: { completion in
                        switch completion {
                            
                        case .finished:
                            break
                        case let .failure(error):
                            continuaion.resume(throwing: error)
                        }
                        self.finishLoading()
                    }, receiveValue: { value in
                        continuaion.resume(returning: value)
                    })
        }
    }
    
    private func finishLoading() {
        isLoading = false
    }
}
