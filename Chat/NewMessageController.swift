//
//  NewMessageController.swift
//  Chat
//
//  Created by Tsenter, David on 7/30/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
class NewMessageController: UITableViewController {
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .Plain, target: self, action: #selector(handleCancel))
        tableView.registerClass(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 72
    }
    func fetchUser(){
        FIRDatabase.database().reference().child("users").observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
            if let dict = snapshot.value as? [String:AnyObject]{
                let user = User()
                user.id = snapshot.key
                //app will crash if class properties dont exactly match with firebase dict keys
                user.email = dict["email"] as? String
                user.name = dict["name"] as? String
                user.profileImageUrl = dict["profileImageUrl"] as? String
                self.users.append(user)
                
                //will crash cuz background thread
                dispatch_async(dispatch_get_main_queue(), { 
                    self.tableView.reloadData()
                })
                

            }
            
            
            }, withCancelBlock: nil)
    }
    func handleCancel(){
        dismissViewControllerAnimated(true, completion: nil)
    }
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let user = users[indexPath.row]
        let cell = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath) as! UserCell
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email

        if let profileImageURL = user.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(profileImageURL)
            /*
            let url = NSURL(string: profileImageURL)
            NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
                if error != nil {
                    print(error)
                    return
                }
                dispatch_async(dispatch_get_main_queue(), {
                    cell.profileImageView.image = UIImage(data:data!)
                })
                
            }).resume()*/
        }
        
        return cell
    }
    var messagesController:MessagesController?
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        dismissViewControllerAnimated(true) {
            let user = self.users[indexPath.row]
            
            self.messagesController?.showChatControllerForUser(user)
        }
    }
}
