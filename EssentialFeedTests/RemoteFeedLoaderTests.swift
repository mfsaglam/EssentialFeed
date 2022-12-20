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
        
        expect(sut, toCompleteWith: .failure(.connectivity)) {
            client.complete(with: clientError)
        }
    }
    
    func test_load_deliversErrorWhenNon200HTTPRespose() {
        let (client, sut) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData)) {
                client.complete(withStatusCode: code, at: index)
            }
        }
    }
    
    func test_load_deliversErrorOn200ResponseWithInvalidJSON() {
        let (client, sut) = makeSUT()
        let invalidJSON = Data("invalid json".utf8)
        
        expect(sut, toCompleteWith: .failure(.invalidData)) {
            client.complete(withStatusCode: 200, data: invalidJSON)
        }
    }
    
    func test_load_deliversNoItemsOn200ResponseCodeWithEmptyJSONList() {
        let (client, sut) = makeSUT()
        
        expect(sut, toCompleteWith: .success([])) {
            let emptyJSONList = Data("{\"items\": []}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSONList)
        }
    }
    
    func test_load_deliversItemsOn200HTTPResponseWithJSONItems() {
        let (client, sut) = makeSUT()
        
        let item1 = makeItem(
            id: UUID(),
            imageURL: URL(string: "https://www.a-given-url.com")!)
        
        let item2 = makeItem(
            id: UUID(),
            description: "a description",
            location: "a location",
            imageURL: URL(string: "https://www.a-given-url.com")!)
        
        let items = [item1.model, item2.model]
                
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJson([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    //MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "https://www.a-given-url.com")!) -> (HTTPClientSpy, RemoteFeedLoader) {
        let client = HTTPClientSpy()
        let sut = RemoteFeedLoader(url: url, client: client)
        return (client, sut)
    }
    
    func makeItem(id: UUID, description: String? = nil, location: String? = nil, imageURL: URL) -> (model: FeedItem, json: [String : Any]) {
        let feedItem = FeedItem(id: id, description: description, location: location, imageURL: imageURL)
        let itemJson = [
            "id": id.uuidString,
            "description": description,
            "location": location,
            "image": imageURL.absoluteString
        ].reduce(into: [String: Any]()) { accumulated, element in
            if let value = element.value { accumulated[element.key] = value }
        }
        
        return (feedItem, itemJson)
    }
    
    func makeItemsJson(_ items: [[String : Any]]) -> Data {
        let json = ["items" : items]
        return try! JSONSerialization.data(withJSONObject: json)
    }
    
    private func expect(_ sut: RemoteFeedLoader, toCompleteWith result: RemoteFeedLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        var capturedResults = [RemoteFeedLoader.Result]()
        
        sut.load { capturedResults.append($0) }
        
        action()
        
        XCTAssertEqual(capturedResults, [result], file: file, line: line)
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
