//
//  ManagedFeedImage.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 4.02.2023.
//

import CoreData

@objc(ManagedFeedImage)
class ManagedFeedImage: NSManagedObject {
    @NSManaged var id: UUID
    @NSManaged var imageDescription: String?
    @NSManaged var location: String?
    @NSManaged var url: URL
    @NSManaged var cache: ManagedCache
    
    var local: LocalFeedImage {
        return LocalFeedImage(id: self.id, description: self.imageDescription, location: self.location, url: self.url)
    }
    
    class func images(from feed: [LocalFeedImage], in context: NSManagedObjectContext) -> NSOrderedSet {
        return NSOrderedSet(array: feed.map {
            let managedImage = ManagedFeedImage.init(context: context)
            managedImage.id = $0.id
            managedImage.imageDescription = $0.description
            managedImage.location = $0.location
            managedImage.url = $0.url
            return managedImage
        })
    }
}
