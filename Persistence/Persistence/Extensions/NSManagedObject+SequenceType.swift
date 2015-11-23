//
//  NSManagedObject+SequenceType.swift
//  Persistence
//
//  Created by Bay Phillips on 11/22/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

extension SequenceType where Generator.Element: NSManagedObject {
    func remapToContext(context: NSManagedObjectContext) -> [Generator.Element] {
        return map { unmappedMO in
            return unmappedMO.ensureOnContext(context)
        }
    }
}

extension NSManagedObject {
    public func ensureOnContext<A: NSManagedObject>(context: NSManagedObjectContext) -> A {
        guard self.managedObjectContext !== context else { return self as! A }
        guard let contextObject = context.objectWithID(self.objectID) as? A else { fatalError("Invalid object type") }
        return contextObject
    }
}