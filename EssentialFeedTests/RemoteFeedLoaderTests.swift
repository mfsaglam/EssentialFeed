//
//  RemoteFeedLoaderTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import XCTest
import EssentialFeed

final class RemoteFeedLoaderTests: XCTestCase {

    func test_init_doesNotRequestDataFromURL() {
        let (client, _) = makeSUT()
                
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    func test_load_requestsDataFromURL() {
        let url = URL(string: "https://www.a-given-url.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_load_requestsDataFromURLTwice() {
        let url = URL(string: "https://www.a-given-url.com")!
        let (client, sut) = makeSUT(url: url)
        
        sut.load() { _ in }
        sut.load() { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorWhenClientError() {
        let (client, sut) = makeSUT()
        var capturedError = [RemoteFeedLoader.Error]()
        let clientError = NSError(domain: "test", code: 0)
        
        sut.load() { capturedError.append($0) }
        client.complete(with: clientError)
        
        XCTAssertEqual(capturedError, [.connectivity])
    }
    
    func test_load_deliversErrorWhenNon200HTTPRespose() {
        let (client, sut) = makeSUT()
        var capturedError = [RemoteFeedLoader.Error]()
        let samples = [199, 201, 300, 400, 500]
        
        samples.forEach { code in
            sut.load() { capturedError.append($0) }
            client.complete(withStatusCode: code)
            
            XCTAssertEqual(capturedError, [.invalidData])
            
            capturedError = []
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://www.a-given-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (client, sut)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (Error?, HTTPURLResponse?) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(error, nil)
        }
        
        func complete(withStatusCode code: Int, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)
            
            messages[index].completion(nil, response)
        }
    }
}
