//
//  URLSessionHTTPClinetTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

class URLSessionHTTPClinetTests: XCTestCase {
    
    
    // MARK: - Helpers
    private func makeSUT(file: StaticString = #filePath,
                         line: UInt = #line) -> HTTPClient {
        let configuration = URLSessionConfiguration.ephemeral
        configuration.protocolClasses = [URLProtocolStub.self]
        let session = URLSession(configuration: configuration)
        
        let sut = URLSessionHTTPClient(session: session)
        trackForMemoryLeaks(sut, file: file, line: line)
        return sut
    }
    
    private func resultValuesFor(
        _ values: (data: Data?, response: URLResponse?, error: Error?),
        file: StaticString = #file,
        line: UInt = #line
    ) async -> (data: Data, response: HTTPURLResponse)? {
        let result = await resultFor(values, file: file, line: line)
        
        switch result {
        case let .success(successResult):
            return successResult
        default:
            XCTFail("Expected success, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultErrorFor(
        _ values: (data: Data?, response: URLResponse?, error: Error?)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) async -> Error? {
        let result = await resultFor(values, file: file, line: line)
        
        switch result {
        case let .failure(error):
            return error
        default:
            XCTFail("Expected failure, got \(result) instead", file: file, line: line)
            return nil
        }
    }
    
    private func resultFor(
        _ values: (data: Data?, response: URLResponse?, error: Error?)?,
        file: StaticString = #file,
        line: UInt = #line
    ) async -> HTTPClient.HTTPResult {
        if let values = values {
            await URLProtocolStub.stub(
                data: values.data,
                response: values.response,
                error: values.error
            )
        }
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.HTTPResult!
        Task {
            let result = try await sut.sendRequest(endpoint: anyURL())
            receivedResult = result
            exp.fulfill()
        }
        
        await fulfillment(of: [exp], timeout: 1.0)
        return receivedResult
    }
    
    
    private func anyData() -> Data {
        return Data("any data".utf8)
    }
    
    private func anyURL() -> URL {
        URL(string: "https://api-example.com/")!
    }
    
    func anyNSError() -> NSError {
        return NSError(domain: "any error",
                       code: 1)
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
