//
//  ContextDidSaveNotification.swift
//  Persistence
//
//  Created by Bay Phillips on 11/22/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

public struct ContextDidSaveNotification {
    private let notification: NSNotification
    public init(note: NSNotification) {
        guard note.name == NSManagedObjectContextDidSaveNotification else {
            fatalError("Wrong notification type passed in")
        }
        self.notification = note
    }
    
    public var insertedObjects: AnyGenerator<ManagedObject> {
        return generatorForKey(NSInsertedObjectsKey)
    }
    
    public var updatedObjects: AnyGenerator<ManagedObject> {
        return generatorForKey(NSUpdatedObjectsKey)
    }
    
    public var deletedObjects: AnyGenerator<ManagedObject> {
        return generatorForKey(NSDeletedObjectsKey)
    }
    
    public var managedObjectContext: NSManagedObjectContext {
        guard let context = notification.object as? NSManagedObjectContext else {
            fatalError("Invalid notification object")
        }
        return context
    }
    
    private func generatorForKey(key: String) -> AnyGenerator<ManagedObject> {
        guard let set = notification.userInfo?[key] as? NSSet else {
            return anyGenerator { nil }
        }
        
        let innerGenerator = set.generate()
        return anyGenerator { return innerGenerator.next() as? ManagedObject }
    }
}

extension NSManagedObjectContext {
    public func addContextDidSaveNotificationObserver(handler: ContextDidSaveNotification -> ()) -> NSObjectProtocol {
        return NSNotificationCenter.defaultCenter().addObserverForName(NSManagedObjectContextDidSaveNotification, object: self, queue: nil, usingBlock: { (note) -> Void in
            let wrappedNotification = ContextDidSaveNotification(note: note)
            handler(wrappedNotification)
        })
    }
    
    public func performMergeChangesFromContextDidSaveNotification(note: ContextDidSaveNotification) -> Void {
        performBlock {
            self.mergeChangesFromContextDidSaveNotification(note.notification)
        }
    }
}