//
//  ManagedCache+CoreDataClass.swift
//  
//
//  Created by Fenominall on 2/7/25.
//
//

import Foundation
import CoreData

@objc(ManagedCache)
final class ManagedCache: NSManagedObject {
    @NSManaged var feed: NSOrderedSet
}

extension ManagedCache {
    var localFeed: [LocalTodoItem] {
        feed.compactMap { ($0 as? ManagedTodoItem)?.lcoal }
    }
}
