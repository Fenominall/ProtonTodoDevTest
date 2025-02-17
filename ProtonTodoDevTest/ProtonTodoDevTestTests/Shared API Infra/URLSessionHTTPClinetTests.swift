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
    ) async -> Data? {
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
        values.map {
            URLProtocolStub.stub(
                data: $0,
                response: $1,
                error: $2
            )
        }
        
        let sut = makeSUT(file: file, line: line)
        let exp = expectation(description: "Wait for completion")
        
        var receivedResult: HTTPClient.HTTPResult!
        Task {
            let result = try await sut
                .sendRequest(endpoint: MockEndpoint(url: anyURL()))
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
        URL(string: "api.example.com")!
    }
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        HTTPURLResponse(
            url: anyURL(),
            statusCode: 200,
            httpVersion: nil,
            headerFields: nil
        )!
    }
    
    private func anyNonHTTPURLResponse() -> URLResponse {
        URLResponse(
            url: anyURL(),
            mimeType: nil,
            expectedContentLength: 0,
            textEncodingName: nil
        )
    }
}
