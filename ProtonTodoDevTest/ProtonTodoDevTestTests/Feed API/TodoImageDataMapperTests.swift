//
//  TodoImageDataMapperTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

class TodoImageDataMapperTests: XCTestCase {
    
    
    func test_map_deliversInvalidDataErrorOn200HTTPResponseWithEmptyData() throws {
        let data = Data()
        
        XCTAssertThrowsError(
            try TodoImageDataMapper.map(
                data,
                from: HTTPURLResponse(statusCode: 200)
            )
        )
    }
    
    func test_map_deliversReceivedNonEmptyDataOn200HTTPURLResponse() throws {
        let data = Data("any data".utf8)
        
        let result = try TodoImageDataMapper.map(
            data,
            from: HTTPURLResponse(statusCode: 200)
        )
        
        XCTAssertEqual(result, data)
    }
}
