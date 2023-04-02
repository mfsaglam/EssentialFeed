//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 2.04.2023.
//

import Foundation
import EssentialFeed

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
    private let FeedLoader: FeedLoader
    var presenter: FeedPresenter?
    
    init(FeedLoader: FeedLoader) {
        self.FeedLoader = FeedLoader
    }
    
    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()
        FeedLoader.load { [weak self] result in
            switch result {
            case let .success(feed):
                self?.presenter?.didFinishLoadingFeed(with: feed)
            case let .failure(error):
                self?.presenter?.didFinishLoadingFeed(with: error)
            }
        }
    }
}
