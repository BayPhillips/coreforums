//
//  NSManagedObjectContext+ManagedObject.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import CoreData

public extension NSManagedObjectContext {
    public func insertObject<A: ManagedObject where A: ManagedObjectType>() -> A {
        guard let object = NSEntityDescription.insertNewObjectForEntityForName(A.entityName, inManagedObjectContext: self) as? A else { fatalError("Wrong object type while inserting") }
        return object
    }
    
    public func saveOrRollback() -> Bool {
        do {
            try save()
            return true
        } catch let error {
            print("Rolling back changes: \(error)")
            rollback()
            return false
        }
    }
    
    public func performChanges(block: () -> ()) -> Void {
        performBlock {
            block()
            self.saveOrRollback()
        }
    }
    
    public func performChangesOnBackgroundThread(block: () -> ()) -> Void {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)) { 
            self.performChanges {
                block()
            }
        }
    }
}