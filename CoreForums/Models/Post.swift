//
//  Post.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

class Post: ManagedObject {
    @NSManaged var body: String
    @NSManaged var conversation: Conversation
    @NSManaged var user: User
    @NSManaged var timeCreated: NSDate
    @NSManaged var timeUpdated: NSDate
}

extension Post: ManagedObjectType {
    static var entityName: String {
        return "Post"
    }
}