//
//  FeedLoader.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 12.12.2022.
//

import Foundation

public protocol FeedLoader {
    typealias Result = Swift.Result<[FeedImage], Error>
    func load(completion: @escaping (Result) -> Void )
}
