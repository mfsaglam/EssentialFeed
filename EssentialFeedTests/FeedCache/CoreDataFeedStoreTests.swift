//
//  CoreDataFeedStoreTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 2.02.2023.
//

import XCTest
import EssentialFeed

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
        let sut = makeSUT()
        
        assertThatRetrieveDeliversFoundValuesOnNonEmptyCache(on: sut)
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
        let bundle = Bundle.init(for: CoreDataFeedStore.self)
        let sut = try! CoreDataFeedStore.init(bundle: bundle)
        trackForMemoryLeak(sut, file: file, line: line)
        return sut
    }
}
