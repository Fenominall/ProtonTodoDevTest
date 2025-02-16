//
//  ThreadSafeDictionary.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/7/25.
//

import Foundation

actor ThreadSafeDictionary<Key: Hashable, Value> {
    
    private var dictionary = [Key: Value]()
    
    subscript(key: Key) -> Value? {
        get { dictionary[key] }
        set { dictionary[key] = newValue }
    }
    
    func setValue(_ value: Value, forKey key: Key) {
        dictionary[key] = value
    }
    
    var count: Int {
        dictionary.count
    }
}
