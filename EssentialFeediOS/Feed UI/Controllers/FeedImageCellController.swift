//
//  FeedImageCellController.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 20.02.2023.
//

import UIKit

protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

final class FeedImageCellController: FeedImageView {
    private let delegate: FeedImageCellControllerDelegate
    private lazy var cell = FeedImageCell.init()
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view() -> UITableViewCell {
        self.delegate.didRequestImage()
        return self.cell
    }
    
    func preload() {
        self.delegate.didRequestImage()
    }
    
    func cancelLoad() {
        self.delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        self.cell.locationContainer.isHidden = !viewModel.hasLocation
        self.cell.locationLabel.text = viewModel.location
        self.cell.descriptionLabel.text = viewModel.description
        self.cell.feedImageView.image = viewModel.image
        self.cell.feedImageContainer.isShimmering = viewModel.isLoading
        self.cell.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        self.cell.onRetry = self.delegate.didRequestImage
    }
}
