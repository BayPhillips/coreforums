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
        let request = Category.sortedFetchRequest
        request.returnsObjectsAsFaults = true
        request.fetchBatchSize = 20
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
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
