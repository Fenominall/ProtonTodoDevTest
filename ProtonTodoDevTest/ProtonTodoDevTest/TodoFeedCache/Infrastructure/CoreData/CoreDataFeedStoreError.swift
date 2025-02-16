//
//  CoreDataFeedStoreError.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/7/25.
//

import Foundation

enum CoreDataFeedStoreError: Error {
    case unableToCreateMutableCopy
    case todoNotFound
    case todoIDMismatch
    case missingManagedObjectContext
}
