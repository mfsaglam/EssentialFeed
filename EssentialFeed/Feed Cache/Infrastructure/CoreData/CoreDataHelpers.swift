//
//  CoreDataHelpers.swift
//  EssentialFeed
//
//  Created by Fatih Sağlam on 4.02.2023.
//

import CoreData

extension NSPersistentContainer {
    private enum LoadError: Error {
        case modelNotFound
        case failedToLoadPersistentStore(Error)
    }
    
    class func loadAndReturn(modelName: String, url: URL, in bundle: Bundle) throws -> NSPersistentContainer {
        guard let momd = NSManagedObjectModel.with(modelName: modelName, in: bundle)
        else { throw LoadError.modelNotFound }
        
        let description = NSPersistentStoreDescription.init(url: url)
        let container = NSPersistentContainer.init(name: "FeedStore", managedObjectModel: momd)
        container.persistentStoreDescriptions = [description]
        
        var loadError: Error?
        container.loadPersistentStores { loadError = $1 }
        try loadError.map { throw LoadError.failedToLoadPersistentStore($0) }
        
        return container
    }
}

extension NSManagedObjectModel {
    class func with(modelName: String, in bundle: Bundle) -> NSManagedObjectModel? {
        return bundle
            .url(forResource: modelName, withExtension: "momd")
            .flatMap { NSManagedObjectModel.init(contentsOf: $0) }
    }
}
