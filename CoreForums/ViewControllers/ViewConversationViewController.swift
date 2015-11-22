//
//  ViewConversationViewController.swift
//  CoreForums
//
//  Created by Bay Phillips on 11/14/15.
//  Copyright © 2015 Bay Phillips. All rights reserved.
//

import UIKit
import CoreData
import Persistence

class PostCell: UITableViewCell, ConfigurableCell {
    func configureForObject(post: Post) {
        self.textLabel?.text = post.body
        self.detailTextLabel?.text = post.user.username
    }
}

class ViewConversationViewController: UITableViewController, ManagedObjectContextSettable {
    var managedObjectContext: NSManagedObjectContext!
    var conversation: Conversation!
    
    var dataSource: TableViewDatasource<ViewConversationViewController, FetchedResultsDataProvider<ViewConversationViewController>, PostCell>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 100.0
        
        let request = Post.sortedFetchRequest
        request.predicate = NSPredicate(format: "conversation = %@", conversation)
        
        let frc = NSFetchedResultsController(fetchRequest: request, managedObjectContext: managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        let dataProvider = FetchedResultsDataProvider(fetchedResultsController: frc, delegate: self)
        dataSource = TableViewDatasource(tableView: tableView, dataProvider: dataProvider, delegate: self)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.title = conversation.title
    }
    
    private var alertController: UIAlertController?
    @IBAction func newReplyButtonTapped() -> Void
    {
        alertController = UIAlertController(title: "Add Reply", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController?.addTextFieldWithConfigurationHandler({ (textField) -> Void in
            textField.placeholder = "Message"
        })
        alertController?.addAction(UIAlertAction(title: "Add", style: UIAlertActionStyle.Default, handler: { (action) -> Void in
            guard let message: String = self.alertController?.textFields?.last?.text else { return }
            self.managedObjectContext.performChanges {
                Post.insertIntoContext(self.managedObjectContext, body: message, user: User.defaultUser, conversation: self.conversation)
            }
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.navigationController?.presentViewController(self.alertController!, animated: true, completion: nil)
    }
}

extension ViewConversationViewController: DataProviderDelegate {
    func dataProviderDidUpdate(updates: [DataProviderUpdate<Post>]?) {
        dataSource.processUpdates(updates)
    }
}

extension ViewConversationViewController: DataSourceDelegate {
    func cellIdentifierForObject(object: Post) -> String {
        return "PostCell"
    }
}
