//
//  Post.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData
import Persistence
import MediaContent

class Post: ManagedObject {
    @NSManaged var body: String
    @NSManaged var conversation: Conversation
    @NSManaged var user: User
    @NSManaged var images: Set<Image>
    @NSManaged var timeCreated: NSDate
    @NSManaged var timeUpdated: NSDate
    
    static func insertIntoContext(moc: NSManagedObjectContext, body: String, user: User, conversation: Conversation) -> Post {
        let post: Post = moc.insertObject()
        post.body = body
        post.user = user
        post.conversation = conversation
        
        post.images.insert(Image.insertIntoContext(moc, imageName: "fakeimage"))
        
        let now = NSDate()
        conversation.lastUpdated = now
        post.timeCreated = now
        post.timeUpdated = now
        
        return post
    }
}

extension Post: ManagedObjectType {
    static var entityName: String {
        return "Post"
    }
    
    static var defaultSortDescriptors: [NSSortDescriptor] {
        return [NSSortDescriptor(key: "timeCreated", ascending: true)]
    }
}