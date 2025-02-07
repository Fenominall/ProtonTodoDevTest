//
//  URLSessionHTTPClient.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class URLSessionHTTPClient: HTTPClient {
    private let session: URLSession
    
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    public enum HTTPClientError: Error {
        case invalidResponse
        case connectivity(Error)
        case serverError(statusCode: Int)
        case clientError(statusCode: Int)
    }
    
    public func get(from url: URL) async throws -> HTTPResult {
        do {
            let (data, response) = try await session.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw HTTPClientError.invalidResponse
            }
            return (data, httpResponse)
        } catch {
            throw HTTPClientError.connectivity(error)
        }
    }
}
