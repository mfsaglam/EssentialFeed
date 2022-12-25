//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 25.12.2022.
//

import XCTest


final class URLSessionHTTPClientTests: XCTestCase {
    
    class URLSessionHTTPClient {
        private let session: URLSession
        
        init(session: URLSession) {
            self.session = session
        }
        
        func get(from url: URL) {
            session.dataTask(with: url) { _, _, _ in
                
            }
        }
    }

    func test_getFromUrl_createsDataTaskWithUrl() {
        let url = URL(string: "http://www.a-url.com")!
        let session = URLSessionSpy()
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(session.receivedURLs, [url])
    }
    
    //MARK: - Helpers
    
    class URLSessionSpy: URLSession {
        var receivedURLs: [URL] = []
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            receivedURLs.append(url)
            return FakeURLSessionDataTask()
        }
    }
    
    class FakeURLSessionDataTask: URLSessionDataTask { }

}
