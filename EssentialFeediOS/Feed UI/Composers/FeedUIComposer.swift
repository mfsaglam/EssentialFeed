//
//  FeedUIComposer.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 21.02.2023.
//

import UIKit
import EssentialFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let presentationAdapter = FeedLoaderPresentationAdapter(
            FeedLoader: MainQueueDispatchDecorator(decoratee: feedLoader)
        )
        
        let feedController = makeFeedViewController(
            delegate: presentationAdapter,
            title: FeedPresenter.title
        )
        
        let feedViewAdapter = FeedViewAdapter(
            controller: feedController,
            imageLoader: MainQueueDispatchDecorator.init(decoratee: imageLoader)
        )
        
        presentationAdapter.presenter = FeedPresenter(
            feedView: feedViewAdapter,
            loadingView: WeakRefVirtualProxy(feedController)
        )
        
        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        let feedController = storyboard.instantiateInitialViewController() as! FeedViewController
        feedController.title = title
        feedController.delegate = delegate
        return feedController
    }
}
