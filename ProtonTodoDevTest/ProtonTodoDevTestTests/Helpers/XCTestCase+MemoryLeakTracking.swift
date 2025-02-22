//
//  XCTestCase+MemoryLeakTracking.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/17/25.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(
        _ instance: AnyObject,
        file: StaticString = #filePath,
        line: UInt = #line) {
            addTeardownBlock { [weak instance] in
                XCTAssertNil(
                    instance, "Instance should have been deallocated. Potenially memory leak",
                    file: file,
                    line: line)
            }
        }
}

