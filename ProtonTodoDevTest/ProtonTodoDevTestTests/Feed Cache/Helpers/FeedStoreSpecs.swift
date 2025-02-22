//
//  FeedStoreSpecs.swift
//  ProtonTodoDevTestTests
//
//  Created by Fenominall on 2/20/25.
//

/// Tests the successful retrieval behavior of a store.
/// Use this for stores that support reading data without errors.
protocol RetrieveStoreSpecs {
    /// Tests that retrieval delivers an empty result when the store is empty.
    func test_retrieve_deliversEmptyOnEmptyStore() async throws
    
    /// Tests that retrieval does not modify the store when it’s empty.
    func test_retrieve_hasNoSideEffectsOnEmptyStore() async throws
    
    /// Tests that retrieval delivers stored data when the store is non-empty.
    func test_retrieve_deliversDataOnNonEmptyStore() async throws
    
    /// Tests that retrieval does not modify the store when it’s non-empty.
    func test_retrieve_hasNoSideEffectsOnNonEmptyStore() async throws
}

/// Tests the failure cases of a store’s retrieval behavior.
/// Use this alongside RetrieveStoreSpecs for stores that can fail.
protocol FailableRetrieveStoreSpecs: RetrieveStoreSpecs {
    /// Tests that retrieval fails appropriately when an error occurs.
    func test_retrieve_deliversFailureOnError() async throws
    
    /// Tests that a failed retrieval does not modify the store.
    func test_retrieve_hasNoSideEffectsOnFailure() async throws
}

/// Tests the successful insertion behavior of a store.
/// Use this for stores that support adding data without errors.
protocol InsertStoreSpecs {
    /// Tests that insertion succeeds on an empty store.
    func test_insert_succeedsOnEmptyStore() async throws
    
    /// Tests that insertion succeeds on a non-empty store.
    func test_insert_succeedsOnNonEmptyStore() async throws
    
    /// Tests that insertion updates existing data in the store or adds new.
    func test_insert_updatesExistingItemsAndAddsNewOnes() async throws
}

/// Tests the failure cases of a store’s insertion behavior.
/// Use this alongside InsertStoreSpecs for stores that can fail.
protocol FailableInsertStoreSpecs: InsertStoreSpecs {
    /// Tests that insertion fails appropriately when an error occurs.
    func test_insert_deliversFailureOnError() async throws
    
    /// Tests that a failed insertion does not modify the store.
    func test_insert_hasNoSideEffectsOnFailure() async throws
}

/// Tests the successful update behavior of a store.
/// Use this for stores that support modifying data without errors.
protocol UpdateStoreSpecs {
    /// Tests that update succeeds on a non-empty store with existing data.
    func test_update_succeedsOnNonEmptyStore() async throws
    
    /// Tests that update modifies the targeted data correctly.
    func test_update_modifiesExistingData() async throws
    
    /// Tests that update has no effect on an empty store (or fails gracefully).
    func test_update_deliversNotFoundErrorOnEmptyStore() async throws
}

/// Tests the failure cases of a store’s update behavior.
/// Use this alongside UpdateStoreSpecs for stores that can fail.
protocol FailableUpdateStoreSpecs: UpdateStoreSpecs {
    /// Tests that update fails appropriately when an error occurs.
    func test_update_deliversFailureOnError() async throws
    
    /// Tests that a failed update does not modify the store.
    func test_update_hasNoSideEffectsOnFailure() async throws
}

/// Tests the successful deletion behavior of a store.
/// Use this for stores that support removing data without errors.
protocol DeleteStoreSpecs {
    /// Tests that deletion succeeds on an empty store.
    func test_delete_succeedsOnEmptyStore() async throws
    
    /// Tests that deletion does not modify the store when it’s empty.
    func test_delete_hasNoSideEffectsOnEmptyStore()
    
    /// Tests that deletion succeeds and clears data on a non-empty store.
    func test_delete_clearsNonEmptyStore() async throws
}

/// Tests the failure cases of a store’s deletion behavior.
/// Use this alongside DeleteStoreSpecs for stores that can fail.
protocol FailableDeleteStoreSpecs: DeleteStoreSpecs {
    /// Tests that deletion fails appropriately when an error occurs.
    func test_delete_deliversFailureOnError() async throws
    
    /// Tests that a failed deletion does not modify the store.
    func test_delete_hasNoSideEffectsOnFailure() async throws
}
