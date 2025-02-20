//
//  TodoFeedItemsMapperTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import XCTest
import ProtonTodoDevTest

final class TodoFeedItemsMapperTests: XCTestCase {
    func test_map_throwsErrorOnInvalidJSONAnd200StatusCode() throws {
        let invalidJson = Data("invalidJson".utf8)
        
        XCTAssertThrowsError(
            try TodoFeedItemsMapper.map(
                invalidJson,
                from: HTTPURLResponse(statusCode: 200)
            )
        )
    }
    
    func test_map_throwsErrorOnInvalidDateFormat() throws {
        let invalidDateJson: [[String: Any]] = [
            [
                "id": UUID().uuidString,
                "title": "A title",
                "description": "A description",
                "completed": false,
                "createdAt": "invalid-date",
                "dueDate": Date().iso8601FormattedString(),
                "imageURL": "https://any-url.com",
                "dependencies": []
            ]
        ]
        
        let json = try makeItemsJSON(invalidDateJson)
        
        XCTAssertThrowsError(
            try TodoFeedItemsMapper.map(
                json,
                from: HTTPURLResponse(statusCode: 200)
            )
        )
    }
    
    func test_map_throwsErrorOnNonUUIDDependenciesArray() throws {
        let invalidDateJson: [[String: Any]] = [
            [
                "id": UUID().uuidString,
                "title": "A title",
                "description": "A description",
                "completed": false,
                "createdAt": Date().iso8601FormattedString(),
                "dueDate": Date().iso8601FormattedString(),
                "imageURL": "https://any-url.com",
                "dependencies": ["invalid-id"]
            ]
        ]
        
        let json = try makeItemsJSON(invalidDateJson)
        
        XCTAssertThrowsError(
            try TodoFeedItemsMapper.map(
                json,
                from: HTTPURLResponse(statusCode: 200)
            )
        )
    }
    
    // MARK: - Success case
    func test_map_deliversNoItemsOn200HTTpResponseWithEmptyList() throws {
        let emptyJson = try makeItemsJSON([])
        
        let result = try TodoFeedItemsMapper.map(
            emptyJson,
            from: HTTPURLResponse(statusCode: 200)
        )
        
        XCTAssertEqual(result, [])
    }
}

extension HTTPURLResponse {
    convenience init(statusCode: Int) {
        self.init(
            url: anyURL(),
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil)!
    }
}
