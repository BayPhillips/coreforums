//
//  ConversationsViewController.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData
import Persistence

class ConversationTableViewCell: UITableViewCell, ConfigurableCell {
    func configureForObject(object: Conversation) {
        self.textLabel?.text = object.title
        self.detailTextLabel?.text = object.creator.username
    }
}

class ConversationsViewController: UITableViewController, ManagedObjectContextSettable {
    var managedObjectContext: NSManagedObjectContext!
    var privateManagedObjectContext: NSManagedObjectContext!
    
    var category: Category!
    
    var dataSource: TableViewDatasource<ConversationsViewController, FetchedResultsDataProvider<ConversationsViewController>, ConversationTableViewCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        let frc = NSFetchedResultsController(fetchRequest: category.conversationsRequest, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDatasource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = category.name
    }
    
    private var alertController: UIAlertController?
    @IBAction func newConversationButtonTapped() -> Void
    {
        alertController = UIAlertController(title: "New Conversation", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Title"
        })
        alertController?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "First message"
        })
        alertController?.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            guard let conversationTitle: String = self.alertController?.textFields?.first?.text else { return }
            guard let conversationMessage: String = self.alertController?.textFields?.last?.text else { return }
            self.privateManagedObjectContext.performChangesOnBackgroundThread {
                Conversation.insertIntoContext(self.privateManagedObjectContext, title: conversationTitle, message: conversationMessage, category: self.category, createdByUser: User.defaultUser)
            }
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.navigationController?.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let conversation: Conversation = dataSource.selectedObject else {
            fatalError("Unable to select a conversation")
        }
        self.performSegueWithIdentifier("view-conversation", sender: conversation)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { fatalError("No identifier for segue") }
        switch identifier {
        case "view-conversation":
            guard let vcvc = segue.destinationViewController as? ViewConversationViewController else {
                fatalError("Unable to cast to ViewConversationViewController")
            }
            guard let conversation = sender as? Conversation else { fatalError("Didn't pass in conversation") }
            vcvc.conversation = conversation
            break
        default:
            break
        }
    }
}

extension ConversationsViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Conversation>]?) {
        dataSource.processUpdates(updates)
    }
}

extension ConversationsViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Conversation) -> String {
        return "ConversationCell"
    }
}