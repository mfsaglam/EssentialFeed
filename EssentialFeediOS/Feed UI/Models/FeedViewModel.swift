//
//  FeedViewModel.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 25.02.2023.
//

import Foundation
import EssentialFeed

final class FeedViewModel {
    private let feedLoader: FeedLoader
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    var isLoading: Bool = false {
        didSet { onChange?(self) }
    }
    
    var onChange: ((FeedViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?
    
    func loadFeed() {
        isLoading = true
        feedLoader.load() { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
