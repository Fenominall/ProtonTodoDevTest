//
//  FeedStoreSpecs.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

import Foundation

/// Tests the retrieval behavior of a store.
/// Use this when your store supports reading data.
protocol RetrieveStoreSpecs {
    /// Tests that retrieval delivers an empty result when the store is empty.
    func test_retrieve_deliversEmptyOnEmptyStore()
    
    /// Tests that retrieval does not modify the store when it’s empty.
    func test_retrieve_hasNoSideEffectsOnEmptyStore()
    
    /// Tests that retrieval delivers stored data when the store is non-empty.
    func test_retrieve_deliversDataOnNonEmptyStore()
    
    /// Tests that retrieval does not modify the store when it’s non-empty.
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore()
    
    /// Tests that retrieval fails appropriately when an error occurs (optional for failable stores).
    func test_retrieve_deliversFailureOnError()
    
    /// Tests that a failed retrieval does not modify the store (optional for failable stores).
    func test_retrieve_hasNoSideEffectsOnFailure()
}

/// Tests the insertion behavior of a store.
/// Use this when your store supports adding new data.
protocol InsertStoreSpecs {
    /// Tests that insertion succeeds on an empty store.
    func test_insert_succeedsOnEmptyStore()
    
    /// Tests that insertion succeeds on a non-empty store.
    func test_insert_succeedsOnNonEmptyStore()
    
    /// Tests that insertion overrides existing data in the store.
    func test_insert_overridesExistingData()
    
    /// Tests that insertion fails appropriately when an error occurs (optional for failable stores).
    func test_insert_deliversFailureOnError()
    
    /// Tests that a failed insertion does not modify the store (optional for failable stores).
    func test_insert_hasNoSideEffectsOnFailure()
}

/// Tests the update behavior of a store.
/// Use this when your store supports modifying existing data.
protocol UpdateStoreSpecs {
    /// Tests that update succeeds on a non-empty store with existing data.
    func test_update_succeedsOnNonEmptyStore()
    
    /// Tests that update modifies the targeted data correctly.
    func test_update_modifiesExistingData()
    
    /// Tests that update has no effect on an empty store (or fails gracefully).
    func test_update_hasNoEffectOnEmptyStore()
    
    /// Tests that update fails appropriately when an error occurs (optional for failable stores).
    func test_update_deliversFailureOnError()
    
    /// Tests that a failed update does not modify the store (optional for failable stores).
    func test_update_hasNoSideEffectsOnFailure()
}

/// Tests the deletion behavior of a store.
/// Use this when your store supports removing data.
protocol DeleteStoreSpecs {
    /// Tests that deletion succeeds on an empty store.
    func test_delete_succeedsOnEmptyStore()
    
    /// Tests that deletion does not modify the store when it’s empty.
    func test_delete_hasNoSideEffectsOnEmptyStore()
    
    /// Tests that deletion succeeds and clears data on a non-empty store.
    func test_delete_clearsNonEmptyStore()
    
    /// Tests that deletion fails appropriately when an error occurs (optional for failable stores).
    func test_delete_deliversFailureOnError()
    
    /// Tests that a failed deletion does not modify the store (optional for failable stores).
    func test_delete_hasNoSideEffectsOnFailure()
}
