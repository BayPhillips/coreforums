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
    @NSManaged var dateCreated: NSDate
    @NSManaged var lastUpdated: NSDate
    @NSManaged var category: Category
    @NSManaged var posts: Set<Post>
    @NSManaged var creator: User
    
    static func insertIntoContext(moc: NSManagedObjectContext, title: String, message: String, category: Category, createdByUser user: User) -> Conversation {
        let conversation: Conversation = moc.insertObject()
        conversation.title = title
        conversation.category = category
        let post = Post.insertIntoContext(moc, body: message, user: user, conversation: conversation)
        conversation.posts.insert(post)
        conversation.creator = user
        conversation.dateCreated = NSDate()
        conversation.lastUpdated = NSDate()
        return conversation
    }
}

extension Conversation: ManagedObjectType {
    static var entityName: String {
        return "Conversation"
    }

    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "lastUpdated", ascending: false)]
    }
}