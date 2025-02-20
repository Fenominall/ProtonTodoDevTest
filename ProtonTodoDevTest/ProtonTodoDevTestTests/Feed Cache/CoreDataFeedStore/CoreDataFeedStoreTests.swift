//
//  CoreDataFeedStoreTests.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation
import XCTest
import ProtonTodoDevTest

typealias CoreDataFeedStoreSpecs = RetrieveStoreSpecs & FailableRetrieveStoreSpecs & InsertStoreSpecs & FailableInsertStoreSpecs & UpdateStoreSpecs & FailableUpdateStoreSpecs

final class CoreDataFeedStoreTests: XCTestCase, CoreDataFeedStoreSpecs  {
    func test_retrieve_deliversEmptyOnEmptyStore() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyStore() {
        
    }
    
    func test_retrieve_deliversDataOnNonEmptyStore() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() {
        
    }
    
    func test_retrieve_deliversFailureOnError() {
        
    }
    
    func test_retrieve_hasNoSideEffectsOnFailure() {
        
    }
    
    func test_insert_succeedsOnEmptyStore() {
        
    }
    
    func test_insert_succeedsOnNonEmptyStore() {
        
    }
    
    func test_insert_overridesExistingData() {
        
    }
    
    func test_insert_deliversFailureOnError() {
        
    }
    
    func test_insert_hasNoSideEffectsOnFailure() {
        
    }
    
    func test_update_succeedsOnNonEmptyStore() {
        
    }
    
    func test_update_modifiesExistingData() {
        
    }
    
    func test_update_hasNoEffectOnEmptyStore() {
        
    }
    
    func test_update_deliversFailureOnError() {
        
    }
    
    func test_update_hasNoSideEffectsOnFailure() {
        
    }
}
