//
//  FeedViewAdapter.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 2.04.2023.
//

import UIKit
import EssentialFeed

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: FeedImageDataLoader
    
    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }
    
    func display(_ feedViewModel: FeedViewModel) {
        self.controller?.tableModel = feedViewModel.feed.map { (model) in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>.init(model: model, imageLoader: imageLoader)
            let view = FeedImageCellController.init(delegate: adapter)
            
            adapter.presenter = FeedImagePresenter.init(
                view: WeakRefVirtualProxy.init(view),
                imageTransformer: UIImage.init
            )
            return view
        }
    }
}
