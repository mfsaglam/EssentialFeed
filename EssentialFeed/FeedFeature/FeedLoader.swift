//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import Foundation

public typealias LoadFeedResult = Result<[FeedImage], Error>

public protocol FeedLoader {
    func load(completion: @escaping (LoadFeedResult) -> Void )
}
