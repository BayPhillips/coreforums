//
//  RootNavigationController.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData

class RootNavigationController: UINavigationController, UINavigationControllerDelegate, ManagedObjectContextSettable {
    var managedObjectContext: NSManagedObjectContext!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        guard let contextSettableViewController = topViewController as? ManagedObjectContextSettable else {
            return
        }
        contextSettableViewController.managedObjectContext = managedObjectContext
    }
    
    override func pushViewController(viewController: UIViewController, animated: Bool) {
        if let contextSettableViewController = viewController as? ManagedObjectContextSettable {
            contextSettableViewController.managedObjectContext = managedObjectContext
        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func presentViewController(viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)?) {
        if let contextSettableViewController = viewControllerToPresent as? ManagedObjectContextSettable {
            contextSettableViewController.managedObjectContext = managedObjectContext
        }
        super.presentViewController(viewControllerToPresent, animated: flag, completion: completion)
    }
}