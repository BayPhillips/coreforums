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
    
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        guard let contextSettableViewController = viewController as? ManagedObjectContextSettable else {
            return
        }
        contextSettableViewController.managedObjectContext = managedObjectContext
    }
}