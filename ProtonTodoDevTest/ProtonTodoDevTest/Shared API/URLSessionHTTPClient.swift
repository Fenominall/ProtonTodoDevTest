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
    
    public func sendRequest(endpoint: URL) async throws -> HTTPResult {
        do {
            let (data, response) = try await session.data(from: endpoint)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw RequestError(fromHttpStatusCode: httpResponse.statusCode)
            }
            
            return .success((data, httpResponse))
        } catch {
            return .failure(handleError(error))
        }
    }
    
    private func handleError(
        _ error: Error
    ) -> RequestError {
        if let error = error as? RequestError {
            return error
        }
        let errorCode = (error as NSError).code
        switch errorCode {
        case NSURLErrorTimedOut:
            return RequestError.timeout
        case NSURLErrorNotConnectedToInternet, NSURLErrorDataNotAllowed:
            return RequestError.noConnection
        case NSURLErrorNetworkConnectionLost:
            return RequestError.lostConnection
        default:
            return RequestError.unknown(error.localizedDescription)
        }
    }
}
