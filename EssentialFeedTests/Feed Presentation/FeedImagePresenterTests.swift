//
//  FeedImagePresenterTests.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 6.04.2023.
//

import XCTest
import EssentialFeed

struct FeedImageViewModel<Image> {
    let description: String?
    let location: String?
    let image: Image?
    let isLoading: Bool
    let shouldRetry: Bool
    var hasLocation: Bool {
        self.location != nil
    }
}

protocol FeedImageView {
    associatedtype Image

    func display(_ viewModel: FeedImageViewModel<Image>)
}

class FeedImagePresenter<View: FeedImageView, Image> where View.Image == Image {
    private let view: View
    
    init(view: View) {
        self.view = view
    }
    
    func didStartLoadingImageData(for model: FeedImage) {
        let viewModel = FeedImageViewModel<Image>(
            description: model.description,
            location: model.location,
            image: nil,
            isLoading: true,
            shouldRetry: false
        )
        self.view.display(viewModel)
    }
}

class FeedImagePresenterTests: XCTestCase {
    
    func test_init_doesNotMessageToView() {
        let (_, view) = makeSUT()

        XCTAssertTrue(view.messages.isEmpty, "Expected no view messages")
    }
    
    func test_didStartLoadingImageData_startsLoading() {
        let (sut, view) = makeSUT()
        let image = makeImage(description: "a description", location: "a location", url: anyURL())
        
        sut.didStartLoadingImageData(for: image)
        
        XCTAssertEqual(view.messages, [
            .display(
                description: image.description,
                location: image.location,
                image: nil,
                isLoading: true,
                shouldRetry: false
            )
        ])
    }
    
    //MARK: - Helpers
    private func makeSUT(file: StaticString = #file, line: UInt = #line) -> (sut: FeedImagePresenter<ViewSpy, FeedImage>, view: ViewSpy) {
        let view = ViewSpy()
        let sut = FeedImagePresenter.init(view: view)
        trackForMemoryLeak(view, file: file, line: line)
        trackForMemoryLeak(sut, file: file, line: line)
        return (sut, view)
    }
    
    private class ViewSpy: FeedImageView {
        typealias Image = FeedImage
                
        enum Message: Hashable {
            case display(
                description: String?,
                location: String?,
                image: Image?,
                isLoading: Bool,
                shouldRetry: Bool
            )
        }
        
        private(set) var messages = Set<Message>()
        
        func display(_ viewModel: FeedImageViewModel<EssentialFeed.FeedImage>) {
            messages.insert(.display(
                description: viewModel.description,
                location: viewModel.location,
                image: viewModel.image,
                isLoading: viewModel.isLoading,
                shouldRetry: viewModel.shouldRetry)
            )
        }
    }
    
    private func makeImage(description: String? = nil, location: String? = nil, url: URL = URL(string: "https://a-url.com")!) -> FeedImage {
        FeedImage(id: UUID(), description: description, location: location, url: url)
    }
}
