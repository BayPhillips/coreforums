//
//  Category.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

class Category: ManagedObject {
    @NSManaged var name: String
    @NSManaged var order: Int16
    @NSManaged var conversations: Set<Conversation>
    
    static func insertIntoContext(moc: NSManagedObjectContext, name: String) -> Category {
        let category: Category = moc.insertObject()
        category.name = name
        return category
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