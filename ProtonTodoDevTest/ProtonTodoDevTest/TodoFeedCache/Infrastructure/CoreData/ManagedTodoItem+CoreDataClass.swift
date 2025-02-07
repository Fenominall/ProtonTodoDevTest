//
//  ManagedTodoItem+CoreDataClass.swift
//  
//
//  Created by Fenominall on 2/7/25.
//
//

import Foundation
import CoreData

@objc(ManagedTodoItem)
final class ManagedTodoItem: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var title: String
    @NSManaged var todoDescription: String
    @NSManaged var completed: Bool
    @NSManaged var createdAt: Date
    @NSManaged var dueDate: Date
    @NSManaged var imageURL: URL?
    @NSManaged var data: Data?
    @NSManaged var cache: ManagedCache
}
