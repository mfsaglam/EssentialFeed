//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import Foundation

public enum LoadFeedResult {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void )
}
