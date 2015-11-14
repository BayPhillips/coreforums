//
//  User.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

class User: ManagedObject {
    @NSManaged var username: String
    @NSManaged var email: String
    @NSManaged var posts: Set<Post>
    @NSManaged var conversations: Set<Conversation>
}

extension User: ManagedObjectType {
    static var entityName: String {
        return "User"
    }
}