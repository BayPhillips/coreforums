//
//  ManagedObjectType+Defaults.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

public extension ManagedObjectType {
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return []
    }
    
    static var sortedFetchRequest: NSFetchRequest {
        let request = NSFetchRequest(entityName: entityName)
        request.sortDescriptors = defaultSortDescriptors
        request.returnsObjectsAsFaults = true
        request.fetchBatchSize = 20
        return request
    }
}