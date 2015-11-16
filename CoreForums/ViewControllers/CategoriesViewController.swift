//
//  CategoriesViewController.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewCell: UITableViewCell, ConfigurableCell {

    func configureForObject(object: Category) {
        self.textLabel?.text = object.name
    }
}

class CategoriesViewController: UITableViewController, ManagedObjectContextSettable {
    
    var managedObjectContext: NSManagedObjectContext!
    var dataSource: TableViewDatasource<CategoriesViewController, FetchedResultsDataProvider<CategoriesViewController>, CategoryTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0

        let frc = NSFetchedResultsController(fetchRequest: Category.sortedFetchRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDatasource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    private var alertController: UIAlertController?
    @IBAction func tappedCreateCategory() -> Void {
        alertController = UIAlertController(title: "New Category", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Category name"
        })
        alertController?.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            guard let categoryName = self.alertController?.textFields?.first?.text else { return }
            self.managedObjectContext.performChanges {
                Category.insertIntoContext(self.managedObjectContext, name: categoryName)
            }
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.navigationController?.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let category = dataSource.selectedObject else { fatalError("Couldn't select category") }
        self.performSegueWithIdentifier("show-conversations", sender: category)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { print("no segue identifier what?"); return }
        
        switch identifier {
        case "show-conversations":
            guard let cvc = segue.destinationViewController as? ConversationsViewController else {
                fatalError("Wrong destination view controller")
            }
            guard let category = sender as? Category else { fatalError("Didn't send in category") }
            cvc.managedObjectContext = self.managedObjectContext
            cvc.category = category
            break
        default:
            break
        }
    }
}

extension CategoriesViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Category>]?) {
        dataSource.processUpdates(updates)
    }
}

extension CategoriesViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Object) -> String {
        return "CategoryCell"
    }
}
