//
//  TreadSafeArray.swift
//  ProtonTodoDevTestiOS
//
//  Created by Fenominall on 2/7/25.
//

import Foundation

actor ThreadSafeArray<Element> {
    private var array: [Element] = []
    
    func append(_ eleemnt: Element) {
        array.append(eleemnt)
    }
    
    func get(at index: Int) -> Element? {
        guard array.indices.contains(index) else { return nil }
        return array[index]
    }
    
    func update(at index: Int, with element: Element) {
        guard self.array.indices.contains(index) else { return }
        self.array[index] = element
    }
    
    func getAllElements() -> [Element] {
        return array
    }
    
    func removeAll() {
        array.removeAll()
    }
    
    var count: Int {
        return array.count
    }
}
