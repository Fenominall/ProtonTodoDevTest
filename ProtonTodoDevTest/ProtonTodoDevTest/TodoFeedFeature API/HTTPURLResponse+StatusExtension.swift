//
//  HTTPURLResponse+StatusExtension.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/6/25.
//

import Foundation

extension HTTPURLResponse {
    var isStatusOK: Bool {
        (200..<300).contains(statusCode)
    }
}
