//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 6.04.2023.
//

import XCTest

class FeedImagePresenter {
    init(view: Any) {
        
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotMessageToView() {
        let view = ViewSpy()
        
        _ = FeedImagePresenter(view: view)
        
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    //MARK: - Helpers
    private class ViewSpy {
        let messages = [Any]()
    }
}
