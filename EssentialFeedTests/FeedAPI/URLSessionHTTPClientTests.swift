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
                
            }.resume()
        }
    }
    
    func test_getFromUrl_resumesDataTaskWithUrl() {
        let url = URL(string: "http://www.a-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url)
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    //MARK: - Helpers
    
    class URLSessionSpy: URLSession {
        private var stubs = [URL : URLSessionDataTask]()
        
        override func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
            return stubs[url] ?? FakeURLSessionDataTask()
        }
        
        func stub(url: URL, task: URLSessionDataTask) {
            stubs[url] = task
        }
    }
    
    class FakeURLSessionDataTask: URLSessionDataTask {
        override func resume() {}
    }
    
    class URLSessionDataTaskSpy: URLSessionDataTask {
        var resumeCallCount = 0
        
        override func resume() {
            resumeCallCount += 1
        }
    }


}
