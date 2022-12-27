//
//  URLSessionHTTPClientTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 25.12.2022.
//

import XCTest
import EssentialFeed

protocol ClientSession {
    func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ClientDataTask
}

protocol ClientDataTask {
    func resume()
}

final class URLSessionHTTPClientTests: XCTestCase {
    
    class URLSessionHTTPClient {
        private let session: ClientSession
        
        init(session: ClientSession) {
            self.session = session
        }
        
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            session.dataTask(with: url) { _, _, error in
                if let error {
                    completion(.failure(error))
                }
            }.resume()
        }
    }
    
    func test_getFromUrl_resumesDataTaskWithUrl() {
        let url = URL(string: "http://www.a-url.com")!
        let session = URLSessionSpy()
        let task = URLSessionDataTaskSpy()
        session.stub(url: url, task: task)
        let sut = URLSessionHTTPClient(session: session)
        
        sut.get(from: url) { _ in }
        
        XCTAssertEqual(task.resumeCallCount, 1)
    }
    
    func test_getFromUrl_failsOnRequestError() {
        let url = URL(string: "http://www.a-url.com")!
        let session = URLSessionSpy()
        let error = NSError(domain: "any error", code: 1)
        session.stub(url: url, error: error)
        let sut = URLSessionHTTPClient(session: session)
        let expectation = expectation(description: "")
        
        sut.get(from: url) { result in
            switch result {
            case let .failure(receivedError as NSError):
                XCTAssertEqual(receivedError, error)
            default:
                XCTFail("")
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 1)
    }
    
    //MARK: - Helpers
    
    class URLSessionSpy: ClientSession {
        private var stubs = [URL : Stub]()
        
        private struct Stub {
            let task: ClientDataTask
            let error: NSError?
        }
        
        func stub(url: URL, task: ClientDataTask = URLSessionDataTaskSpy(), error: NSError? = nil) {
            stubs[url] = Stub(task: task, error: error)
        }
        
        func dataTask(with url: URL, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> ClientDataTask {
            guard let stub = stubs[url] else {
                fatalError("Couldn't find stub for \(url)")
            }
            completionHandler(nil, nil, stub.error)
            return stub.task
        }
    }
    
    class FakeURLSessionDataTask: ClientDataTask {
        func resume() {}
    }
    
    class URLSessionDataTaskSpy: ClientDataTask {
        var resumeCallCount = 0
        
        func resume() {
            resumeCallCount += 1
        }
    }


}
