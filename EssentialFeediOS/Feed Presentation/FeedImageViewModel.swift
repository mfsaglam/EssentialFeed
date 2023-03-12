//
//  FeedImageViewModel.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 27.02.2023.
//

import Foundation
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
