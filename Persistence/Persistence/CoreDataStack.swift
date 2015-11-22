//
//  CoreDataStack.swift
//  Persistence
//
//  Created by Bay Phillips on 11/21/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

public class CoreDataStack {
    private static let forumsStoreUrl = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!.URLByAppendingPathComponent("CoreForums.forums")
    
    public class func generateContextsWithClasses(classes: [AnyClass]) -> [NSManagedObjectContextConcurrencyType: NSManagedObjectContext] {
        let bundles: [NSBundle] = classes.map({ return NSBundle(forClass: $0)})
        
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("Couldn't load model from bundles: \(bundles)")
        }
        
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: forumsStoreUrl, options: options)
        
        let mainContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        mainContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        let privateContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType)
        privateContext.persistentStoreCoordinator = persistentStoreCoordinator
        
        return [
            NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType: mainContext,
            NSManagedObjectContextConcurrencyType.PrivateQueueConcurrencyType: privateContext
        ]
    }
}
