//
//  Category.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData
import Persistence

class Category: ManagedObject {
    @NSManaged var name: String
    @NSManaged var order: Int16
    @NSManaged var conversations: Set<Conversation>
    
    static func insertIntoContext(moc: NSManagedObjectContext, name: String) -> Category {
        let category: Category = moc.insertObject()
        category.name = name
        return category
    }
    
    var conversationsRequest: NSFetchRequest {
        get {
            let request = NSFetchRequest(entityName: Conversation.entityName)
            request.predicate = NSPredicate(format: "category = %@", self)
            request.sortDescriptors = Conversation.defaultSortDescriptors
            return request
        }
    }
}

extension Category: ManagedObjectType {
    static var entityName: String {
        return "Category"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "order", ascending: true), NSSortDescriptor(key: "name", ascending: true)]
    }
}