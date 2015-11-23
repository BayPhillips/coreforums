//
//  ManagedObjectContextSettable.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

public protocol ManagedObjectContextSettable: class {
    var managedObjectContext: NSManagedObjectContext! { get set }
    var privateManagedObjectContext: NSManagedObjectContext! { get set }
    func setContextsWithMainThreadContext(mtc: NSManagedObjectContext, andPrivateThreadContext ptc: NSManagedObjectContext) -> Void
}

public extension ManagedObjectContextSettable {
    func setContextsWithMainThreadContext(mtc: NSManagedObjectContext, andPrivateThreadContext ptc: NSManagedObjectContext) -> Void {
        self.managedObjectContext = mtc
        self.privateManagedObjectContext = ptc
    }
}