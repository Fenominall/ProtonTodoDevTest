//
//  TodoimageLoader.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

protocol TodoimageLoader {
    func loadImage(from url: URL) async throws -> Data
}
