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
    var privateManagedObjectContext: NSManagedObjectContext!
    
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
            self.privateManagedObjectContext.performChangesOnBackgroundThread {
                Post.insertIntoContext(self.privateManagedObjectContext, body: message, user: User.defaultUser, conversation: self.conversation)
            }
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: { (action) -> Void in
            self.alertController?.dismissViewControllerAnimated(true, completion: nil)
        }))
        self.navigationController?.presentViewController(self.alertController!, animated: true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        guard let selectedPost: Post = dataSource.selectedObject else {
            fatalError("Couldn't retrieve post to edit")
        }
        alertController = UIAlertController(title: "Edit Post", message: nil, preferredStyle: UIAlertControllerStyle.Alert)
        alertController?.addTextFieldWithConfigurationHandler { textField in
            textField.text = selectedPost.body
        }
        alertController?.addAction(UIAlertAction(title: "Edit", style: UIAlertActionStyle.Default, handler: { [weak self] (action) -> Void in
            guard let newBody = self?.alertController?.textFields?.first?.text else {
                fatalError("Couldn't get text for edit field")
            }
            if newBody != selectedPost.body {
                self?.privateManagedObjectContext.performChangesOnBackgroundThread { [weak self] in
                    let post: Post = selectedPost.ensureOnContext((self?.privateManagedObjectContext)!)
                    post.body = newBody
                }
            }
        }))
        alertController?.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: nil))
        self.navigationController?.presentViewController(alertController!, animated: true, completion: nil)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
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
