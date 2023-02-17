//
//  FeedImageDataLoader.swift
//  EssentialFeediOS
//
//  Created by Fatih Sağlam on 17.02.2023.
//

import Foundation
import EssentialFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
