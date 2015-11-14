//
//  Conversation.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

class Conversation: ManagedObject {
    @NSManaged var title: String
    @NSManaged var category: Category
    @NSManaged var posts: Set<Post>
    @NSManaged var creator: User
}

extension Conversation: ManagedObjectType {
    static var entityName: String {
        return "Conversation"
    }
}