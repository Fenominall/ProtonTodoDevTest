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
    
    override func tearDown() async throws {
        try await super.tearDown()
        
        await URLProtocolStub.removeStub()
    }
    
    func test_sendRequest_perormsGETRequestWithURL() async throws {
        let url = anyURL()
        let exp = expectation(description: "Wait for completion")
        
        await URLProtocolStub.observeRequests { request in
            XCTAssertEqual(request.url, url)
            XCTAssertEqual(request.httpMethod, "GET")
            exp.fulfill()
        }
        
        _ = try await makeSUT().sendRequest(endpoint: url)
        
        await fulfillment(of: [exp], timeout: 1.0)
    }
    
    func test_getFromURL_failsOnRequestError() async {
        let requestError = anyNSError()
        
        let receivedError = await resultErrorFor((data: nil, response: nil, error: requestError))
        
        XCTAssertNotNil(receivedError)
    }
    
    func test_sndRequest_failsOnAllInvalidRepresentationCases() async {
        let oneErrorCase = await resultErrorFor((data: nil, response: nil, error: nil))
        let twoErrorCase = await resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: nil))
        let threeErrorCase = await resultErrorFor((data: anyData(), response: nil, error: nil))
        let fourErrorCase = await resultErrorFor((data: anyData(), response: nil, error: anyNSError()))
        let fiveErrorCase = await resultErrorFor((data: nil, response: nonHTTPURLResponse(), error: anyNSError()))
        let sixErrorCase = await resultErrorFor((data: nil, response: anyHTTPURLResponse(), error: anyNSError()))
        let sevenErrorCase = await resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: anyNSError()))
        let eigthErrorCase = await resultErrorFor((data: anyData(), response: anyHTTPURLResponse(), error: anyNSError()))
        let nineErrorCase = await resultErrorFor((data: anyData(), response: nonHTTPURLResponse(), error: nil))
        
        XCTAssertNotNil(oneErrorCase)
        XCTAssertNotNil(twoErrorCase)
        XCTAssertNotNil(threeErrorCase)
        XCTAssertNotNil(fourErrorCase)
        XCTAssertNotNil(fiveErrorCase)
        XCTAssertNotNil(sixErrorCase)
        XCTAssertNotNil(sevenErrorCase)
        XCTAssertNotNil(eigthErrorCase)
        XCTAssertNotNil(nineErrorCase)
    }
    
    func test_getFromURL_succeedsOnHTTPURLResponseWithData() async throws {
        let item1 = makeItem(id: UUID(), dependencies: [])
        let item2 = makeItem(id: UUID(), dependencies: [item1.model.id])
        let jsonData = try makeItemsJSON([item1.json, item2.json])
        
        let response = anyHTTPURLResponse()
        
        let receivedValues = await resultValuesFor((data: jsonData, response: response, error: nil))
        
        XCTAssertNotNil(receivedValues?.data)
        XCTAssertEqual(receivedValues?.data, jsonData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
    func test_getFromURL_succeedsWithEmptyDataOnHTTPURLResponseWithNilData() async {
        let response = anyHTTPURLResponse()
        
        let receivedValues = await resultValuesFor((data: nil, response: response, error: nil))
        
        let emptyData = Data()
        XCTAssertEqual(receivedValues?.data, emptyData)
        XCTAssertEqual(receivedValues?.response.url, response.url)
        XCTAssertEqual(receivedValues?.response.statusCode, response.statusCode)
    }
    
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
    
    private func anyHTTPURLResponse() -> HTTPURLResponse {
        return HTTPURLResponse(url: anyURL(), statusCode: 200, httpVersion: nil, headerFields: nil)!
    }
    
    private func nonHTTPURLResponse() -> URLResponse {
        return URLResponse(url: anyURL(), mimeType: nil, expectedContentLength: 0, textEncodingName: nil)
    }
}
