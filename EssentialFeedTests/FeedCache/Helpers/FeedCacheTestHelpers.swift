//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Fatih Sağlam on 17.01.2023.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (model: [FeedImage], local: [LocalFeedImage]) {
    let feed = [uniqueImage(), uniqueImage()]
    let localFeed = feed.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }
    return (model: feed, local: localFeed)
}


extension Date {
    
    func minusFeedMaxAge() -> Date {
        adding(days: -feedCacheMaxDaysInAge)
    }
    
    private var feedCacheMaxDaysInAge: Int {
        7
    }
    
    private func adding(days: Int) -> Date {
        return Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }
}

extension Date {
    
    func adding(seconds: TimeInterval) -> Date {
        return self + seconds
    }
}
    
