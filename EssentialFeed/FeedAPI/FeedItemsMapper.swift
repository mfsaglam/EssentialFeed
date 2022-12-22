//
//  FeedItemsMapper.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 22.12.2022.
//

import Foundation

internal class FeedItemsMapper {
    
    private struct Root: Decodable {
        let items: [Item]
    }

    private struct Item: Decodable {
        let id: UUID
        let description: String?
        let location: String?
        let image: String
        
        var item: FeedItem {
            return FeedItem(id: id, description: description, location: location, imageURL: URL(string: image)!)
        }
    }
    
    private static var OK_200: Int { return 200 }

    internal static func map(_ data: Data, response: HTTPURLResponse) throws -> [FeedItem] {
        guard response.statusCode == OK_200 else {
            throw RemoteFeedLoader.Error.invalidData
        }
        let decoder = JSONDecoder()
        let root = try decoder.decode(Root.self, from: data)
        return root.items.map { $0.item }
    }
}
