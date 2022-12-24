//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import Foundation

public enum LoadFeedResult<Error: Swift.Error> {
    case success([FeedItem])
    case failure(Error)
}

protocol FeedLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadFeedResult<Error>) -> Void )
}
