//
//  AppDelegate.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var managedObjectContext: NSManagedObjectContext!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        managedObjectContext = createCoreForumsContext()
        
        guard let categoriesViewController = window?.rootViewController as? ManagedObjectContextSettable else
        {
            fatalError("window.rootViewController doesn't adhere to the ManagedObjectContextSettable protocol.")
        }
        
        categoriesViewController.managedObjectContext = managedObjectContext
        
        return true
    }
    
    private let forumsStoreUrl = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.UserDomainMask).first!.URLByAppendingPathComponent("CoreForums.forums")
    
    func createCoreForumsContext() -> NSManagedObjectContext
    {
        let bundles: [NSBundle] = [
            Category.self,
            Conversation.self,
            Post.self,
            User.self
        ].map({ return NSBundle(forClass: $0)})
        
        guard let model = NSManagedObjectModel.mergedModelFromBundles(bundles) else {
            fatalError("Couldn't load model from bundles: \(bundles)")
        }
        
        let options = [
            NSMigratePersistentStoresAutomaticallyOption: true,
            NSInferMappingModelAutomaticallyOption: true
        ]
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: model)
        try! persistentStoreCoordinator.addPersistentStoreWithType(NSSQLiteStoreType, configuration: nil, URL: forumsStoreUrl, options: options)
        
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.MainQueueConcurrencyType)
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

}

