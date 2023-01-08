//
//  RemoteFeedItem.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 8.01.2023.
//

import Foundation

internal struct RemoteFeedItem: Decodable {
    let id: UUID
    let description: String?
    let location: String?
    let image: URL
}
