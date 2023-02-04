//
//  FeedCachePolicy.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 19.01.2023.
//

import Foundation

final class FeedCachePolicy {
    private init() { }
    
    static let calendar = Calendar(identifier: .gregorian)
    
    static private var maxCacheAgeInDays: Int {
        return 7
    }
    
    static func validate(_ timestamp: Date, against currentDate: Date) -> Bool {
        guard let maxAge = calendar.date(byAdding: .day, value: maxCacheAgeInDays, to: timestamp) else { return false }
        return currentDate < maxAge
    }
}
