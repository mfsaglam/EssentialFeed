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
        let clientError = NSError(domain: "test", code: 0)
        
        expect(sut, toCompleteWithError: .connectivity) {
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorWhenNon200HTTPRespose() {
        let (client, sut) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWithError: .invalidData) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidJSON() {
        let (client, sut) = makeSUT()
        let invalidJSON = Data("invalid json".utf8)
        
        expect(sut, toCompleteWithError: .invalidData) {
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://www.a-given-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (client, sut)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWithError error: RemoteFeedLoader.Error, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [.failure(error)], file: file, line: line)
    }
    
    private class HTTPClientSpy: HTTPClient {
        var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        var requestedURLs: [URL] {
            messages.map { $0.url }
        }

        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url,completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data = Data(), at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil)!
            
            messages[index].completion(.success(data, response))
        }
    }
}
