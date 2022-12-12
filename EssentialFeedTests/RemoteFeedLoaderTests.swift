//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import XCTest

class RemoteFeedLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init() {
        let _ = RemoteFeedLoader()
        let client = HTTPClient()
                
        XCTAssertNil(client.requestedURL)
    }
}
