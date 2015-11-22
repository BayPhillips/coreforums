//
//  FetchedResultsDataProvider.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import Foundation
import CoreData

public class FetchedResultsDataProvider<Delegate: DataProviderDelegate>: NSObject, NSFetchedResultsControllerDelegate, DataProvider {
    
    public typealias Object = Delegate.Object
    
    private let fetchedResultsController: NSFetchedResultsController
    private weak var delegate: Delegate!
    private var updates: [DataProviderUpdate<Object>] = []
    
    public init(fetchedResultsController: NSFetchedResultsController, delegate: Delegate) {
        self.fetchedResultsController = fetchedResultsController
        self.delegate = delegate
        super.init()
        fetchedResultsController.delegate = self
        try! fetchedResultsController.performFetch()
    }
    
    public func objectAtIndexPath(indexPath: NSIndexPath) -> Object {
        guard let result = fetchedResultsController.objectAtIndexPath(indexPath) as? Object else {
            fatalError("Unexpected object returned at \(indexPath)")
        }
        
        return result
    }
    
    public func numberOfItemsInSection(section: Int) -> Int {
        guard let sections = fetchedResultsController.sections?[section] else { return 0 }
        return sections.numberOfObjects
    }
    
    public func controllerWillChangeContent(controller: NSFetchedResultsController) {
        updates = []
    }
    
    public func controller(controller: NSFetchedResultsController, didChangeObject anObject: AnyObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        switch type {
        case .Insert:
            guard let indexPath = newIndexPath else { fatalError("indexPath should not be nil") }
            updates.append(DataProviderUpdate.Insert(indexPath))
            break
        case .Update:
            guard let indexPath = indexPath else { fatalError("indexPath should not be nil") }
            let object = objectAtIndexPath(indexPath)
            updates.append(DataProviderUpdate.Update(indexPath, object))
            break
        case .Move:
            guard let indexPath = indexPath else { fatalError("indexPath should not be nil") }
            guard let newIndexPath = newIndexPath else { fatalError("Couldn't move to a nil index path") }
            updates.append(DataProviderUpdate.Move(indexPath, newIndexPath))
            break
        case .Delete:
            guard let indexPath = indexPath else { fatalError("indexPath should not be nil") }
            updates.append(DataProviderUpdate.Delete(indexPath))
            break
        }
    }
    
    public func controllerDidChangeContent(controller: NSFetchedResultsController) {
        delegate.dataProviderDidUpdate(updates)
    }
}