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
    private var cell: FeedImageCell?
    
    init(delegate: FeedImageCellControllerDelegate) {
        self.delegate = delegate
    }
    
    func view(in tableView: UITableView) -> UITableViewCell {
        cell = tableView.dequeueReusableCell()
        delegate.didRequestImage()
        return cell!
    }
    
    func preload() {
        self.delegate.didRequestImage()
    }
    
    func cancelLoad() {
        releaseCellForReuse()
        self.delegate.didCancelImageRequest()
    }
    
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        self.cell?.locationContainer.isHidden = !viewModel.hasLocation
        self.cell?.locationLabel.text = viewModel.location
        self.cell?.descriptionLabel.text = viewModel.description
        self.cell?.feedImageView.image = viewModel.image
        self.cell?.feedImageContainer.isShimmering = viewModel.isLoading
        self.cell?.feedImageRetryButton.isHidden = !viewModel.shouldRetry
        self.cell?.onRetry = self.delegate.didRequestImage
    }
    
    private func releaseCellForReuse() {
        cell = nil
    }
}
