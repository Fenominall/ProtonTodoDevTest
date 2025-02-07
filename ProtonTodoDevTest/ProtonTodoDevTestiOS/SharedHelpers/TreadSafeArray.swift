//
//  TreadSafeArray.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/7/25.
//

import Foundation

final class ThreadSafeArrat<Element> {
    private var array: [Element] = []
    private var queue = DispatchQueue(label: "swift.threadSafeDictionary.com", attributes: .concurrent)
    
    func append(_ eleemnt: Element) {
        queue.async(flags: .barrier) {
            self.array.append(eleemnt)
        }
    }
    
    func get(at index: Int) -> Element? {
        queue.sync {
            guard array.indices.contains(index) else { return nil }
            return array[index]
        }
    }
    
    func update(at index: Int, with element: Element) {
        queue.async(flags: .barrier) {
            guard self.array.indices.contains(index) else { return }
            self.array[index] = element
        }
    }
    
    func getAllElements() -> [Element] {
        queue.sync {
            return array
        }
    }
    
    var count: Int {
        queue.sync {
            return array.count
        }
    }
}
