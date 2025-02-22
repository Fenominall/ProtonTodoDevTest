//
//  ManagedTodoDependency.swift
//  ProtonTodoDevTest
//
//  Created by Fenominall on 2/11/25.
//

import Foundation
import CoreData

@objc(ManagedTodoDependency)
final class ManagedTodoDependency: NSManagedObject {
    @NSManaged var id: UUID
}
