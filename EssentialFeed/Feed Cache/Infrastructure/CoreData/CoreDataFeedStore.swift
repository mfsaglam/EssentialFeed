//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 4.02.2023.
//

import CoreData

public class CoreDataFeedStore: FeedStore {
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    public init(storeURL: URL, bundle: Bundle = .main) throws {
        self.container = try NSPersistentContainer.loadAndReturn(modelName: "FeedStore", url: storeURL, in: bundle)
        self.context = self.container.newBackgroundContext()
    }
    
    public func deleteCachedFeed(completion: @escaping DeletionCompletion) {
        perform { context in
            do {
                try ManagedCache.find(in: context).map(context.delete).map(context.save)
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timestamp: Date, completion: @escaping InsertionCompletion) {
        perform { context in
            do {
                let managedCache = try ManagedCache.firstInstance(in: context)
                managedCache.timestamp = timestamp
                managedCache.feed = ManagedFeedImage.images(from: feed, in: context)
                
                try context.save()
                completion(nil)
            } catch {
                completion(error)
            }
        }
    }
    
    public func retrieve(completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try ManagedCache.find(in: context) {
                    completion(.found(feed: cache.localFeed, timestamp: cache.timestamp))
                } else {
                    completion(.empty)
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    private func perform(action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}

@objc(ManagedCache)
private class ManagedCache: NSManagedObject {
     @NSManaged var timestamp: Date
     @NSManaged var feed: NSOrderedSet
    
    var localFeed: [LocalFeedImage] {
        return self.feed.compactMap { ($0 as? ManagedFeedImage)?.local }
    }
    
    class func find(in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>.init(entityName: Self.entity().name!)
        request.returnsObjectsAsFaults = false
        return try? context.fetch(request).first
    }
    
    class func firstInstance(in context: NSManagedObjectContext) throws -> ManagedCache {
        try Self.find(in: context).map { context.delete($0) }
        return ManagedCache.init(context: context)
    }
}

@objc(ManagedFeedImage)

private class ManagedFeedImage: NSManagedObject {
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
