//
//  FeedPresenterTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 2.04.2023.
//

import XCTest
import EssentialFeed

class FeedPresenterTests: XCTestCase {
    
    func test_title_isLocalized() {
        XCTAssertEqual(FeedPresenter.title, localized("feed_view_title"))
    }
    func test_init_doesNotSendMessagesToView() {
        let (_, view) = makeSUT()
                
        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages.")
    }
    
//    func test_didStartLoadingFeed_displaysNoErrorMessageAndStartsLoading() {
//        let (sut, view) = makeSUT()
//        
//        sut.didStartLoadingFeed()
//        
//        XCTAssertEqual(view.messages, [
//            .display(errorMessage: .none),
//            .display(isLoading: true)
//        ])
//    }
    
    func test_didFinishLoadingFeed_displaysFeedAndStopsLoading() {
        let (sut, view) = makeSUT()
        let feed = uniqueImageFeed().model
        
        sut.didFinishLoadingFeed(with: feed)
        
        XCTAssertEqual(view.messages, [
            .display(feed: feed),
            .display(isLoading: false)
        ])
    }
    
//    func test_didFinishLoadingFeedWithError_displaysLocalizedErrorMessageAndStopsLoading() {
//        let (sut, view) = makeSUT()
//        let feed = uniqueImageFeed().model
//
//        sut.didFinishLoadingFeed(with: anyNSError())
//
//        XCTAssertEqual(view.messages, [
//            .display(errorMessage: localized("feed_view_connection_error")),
//            .display(isLoading: false)
//        ])
//    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedPresenter, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedPresenter(feedView: view, loadingView: view)
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }
    
    private func localized(_ key: String, file: StaticString = #file, line: UInt = #line) -> String {
        let table = "Feed"
        let bundle = Bundle(for: FeedPresenter.self)
        let value = bundle.localizedString(forKey: key, value: nil, table: "Feed")
        if value == key {
            XCTFail("Missing localized string for key: \(key) in table: \(table)", file: file, line: line)
        }
        return value
    }
    
    private class ViewSpy: FeedView, FeedLoadingView {

        enum Message: Hashable {
            case display(errorMessage: String?)
            case display(isLoading: Bool)
            case display(feed: [FeedImage])
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: FeedViewModel) {
            messages.insert(.display(feed: viewModel.feed))
        }
        
        func display(_ viewModel: FeedLoadingViewModel) {
            messages.insert(.display(isLoading: viewModel.isLoading))
        }
    }
    
//    extension ViewSpy: FeedErrorView {
//        func display(_ viewModel: FeedErrorViewModel) {
//            messages.insert(.display(errorMessage: viewModel.message))
//        }
//    }
}
