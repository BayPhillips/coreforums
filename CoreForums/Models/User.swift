//
//  User.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData
import Persistence

class User: ManagedObject {
    @NSManaged var username: String
    @NSManaged var emailAddress: String
    @NSManaged var posts: Set<Post>
    @NSManaged var conversations: Set<Conversation>
    
    static let defaultUser: User = {
        guard let context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as? AppDelegate)?.managedObjectContext else {
            fatalError("Couldn't retrieve managedObjectContext for default user")
        }
        let defaultEmailAddress = "default@default.com"
        let request = NSFetchRequest(entityName: User.entityName)
        request.predicate = NSPredicate(format: "emailAddress == %@", defaultEmailAddress)
        request.sortDescriptors = User.defaultSortDescriptors
        let frc: NSFetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        try! frc.performFetch()
        
        if let user: User = frc.sections?.first?.objects?.first as? User {
            return user
        } else {
            let user = User.insertIntoContext(context, username: "default", email: defaultEmailAddress)
            context.saveOrRollback()
            return user
        }
    }()
    
    static func insertIntoContext(moc: NSManagedObjectContext, username: String, email: String) -> User {
        let user: User = moc.insertObject()
        user.username = username
        user.emailAddress = email
        return user
    }
}


extension User: ManagedObjectType {
    static var entityName: String {
        return "User"
    }
}