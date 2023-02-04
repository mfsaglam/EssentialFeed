//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 2.02.2023.
//

import XCTest
import EssentialFeed

class CoreDataFeedStore: FeedStore {
    func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        
    }
    
    func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        
    }
    
    func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}

class CoreDataFeedStoreTests: XCTestCase, FeedStoreSpecs {
    
    func test_retrieve_deliversEmptyOnEmptyCache() {
        let sut = makeSUT()
        
        assertThateRetrieveDeliversEmptyOnEmptyCache(on: sut)
        
    }
    
    func test_retrieve_hasNoSideEffectsOnEmptyCache() {
        let sut = makeSUT()
        
        assertThatRetrieveHasNoSideEffectsOnEmptyCache(on: sut)
    }
    
    func test_retrieve_deliversFoundValuesOnNonEmptyCache() {

    }
    
    func test_retrieve_hasNoSideEffectsOnNonEmptyCache() {

    }
    
    func test_insert_overridesPreviouslyInsertedCacheValues() {

    }
    
    func test_delete_hasNoSideEffectsOnEmptyCache() {

    }
    
    func test_delete_emptiesPreviouslyInsertedCache() {

    }
    
    func test_storeSideEffects_runSerially() {

    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> CoreDataFeedStore {
        let sut = CoreDataFeedStore.init()
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
