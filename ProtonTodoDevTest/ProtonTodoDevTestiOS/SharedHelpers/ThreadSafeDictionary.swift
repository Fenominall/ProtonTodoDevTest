//
//  ThreadSafeDictionary.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/7/25.
//

import Foundation

final class ThreadSafeDictionary<Key: Hashable, Value> {
    
    private var dictionary = [Key: Value]()
    private var queue = DispatchQueue(label: "swift.threadSafeDictionary.com", attributes: .concurrent)
    
    subscript(key: Key) -> Value? {
        get {
            var value: Value?
            queue.sync {
                value = dictionary[key]
            }
            return value
        }
        set(newValue) {
            // ThreadSafeArray owns the queue, and the queue does not outlive ThreadSafeArray
            // Weak self not needed
            queue.async(flags:. barrier) {
                self.dictionary[key] = newValue
            }
        }
    }
}
