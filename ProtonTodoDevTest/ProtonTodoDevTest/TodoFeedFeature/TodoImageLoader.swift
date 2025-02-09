//
//  TodoimageLoader.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

public protocol TodoImageLoader {
    func loadImage(from url: URL) async throws -> Data
}
