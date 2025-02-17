//
//  TodoFeedImageMapper.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public final class TodoImageDataMapper {
    private enum Error: Swift.Error {
        case invalidData
    }
    
    public static func map(
        _ data: Data,
        from response: HTTPURLResponse
    ) throws -> Data {
        guard !data.isEmpty else {
            throw Error.invalidData
        }
        
        return data
    }
}
