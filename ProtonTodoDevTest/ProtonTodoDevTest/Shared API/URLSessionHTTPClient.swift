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
    
    public func sendRequest(endpoint: any Endpoint) async throws -> Result<HTTPResult, RequestError> {
        guard let urlRequest = Request.buildURLRequest(from: endpoint) else {
            return .failure(.urlMalformed)
        }
        
        do {
            let (data, response) = try await session.data(for: urlRequest)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw RequestError.noResponse
            }
            
            guard 200..<300 ~= httpResponse.statusCode else {
                throw RequestError(fromHttpStatusCode: httpResponse.statusCode)
            }
            
            return .success(data)
        } catch {
            return .failure(handleError(urlRequest, error))
        }
    }
    
    private func handleError(
        _ request: URLRequest,
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
