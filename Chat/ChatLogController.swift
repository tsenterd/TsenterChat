//
//  ChatLogController.swift
//  Chat
//
//  Created by Tsenter, David on 7/30/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate,UICollectionViewDelegateFlowLayout {
    
    
    var user:User? {
        didSet{
            navigationItem.title = user?.name
            
            observeMessages()
        }
    }
    var messages = [Message]()
    func observeMessages(){
        guard let uid = FIRAuth.auth()?.currentUser?.uid else {return}
        
        let userMessageRef = FIRDatabase.database().reference().child("user-messages").child(uid)
        
        userMessageRef.observeEventType(.ChildAdded, withBlock: { (snapshot) in
            
                let messageId = snapshot.key
            
                let messagesRef = FIRDatabase.database().reference().child("messages").child(messageId)
            
                messagesRef.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                    
                    guard let  dict = snapshot.value as? [String:AnyObject] else {return}
                    
                    let message = Message()
                    message.setValuesForKeysWithDictionary(dict)
                    
                    if message.chatPartnerId() == self.user?.id{
                        self.messages.append(message)
                        dispatch_async(dispatch_get_main_queue(), {
                            self.collectionView?.reloadData()
                        })
                    }
                    
                    }, withCancelBlock: nil)
            
            }, withCancelBlock: nil)
    }
    
    
    lazy var inputTextField:UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter Message..."
        textField.translatesAutoresizingMaskIntoConstraints = false;
        textField.delegate = self
        return textField
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.alwaysBounceVertical = true
        collectionView?.backgroundColor = UIColor.whiteColor()
        collectionView?.registerClass(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView?.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        setupInputComponents()
    }
    
    func setupInputComponents(){
    
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.backgroundColor = UIColor.whiteColor()
        view.addSubview(containerView)
        
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
    
        
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false;
        sendButton.addTarget(self, action: #selector(handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
       
        
        containerView.addSubview(inputTextField)
        
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor,constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(r: 220, g: 220, b: 220)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false;
        containerView.addSubview(separatorLine)
        
        separatorLine.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        separatorLine.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        separatorLine.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        separatorLine.heightAnchor.constraintEqualToConstant(1).active = true
        
    }
    func handleSend(){
        if inputTextField.text != nil && inputTextField.text != ""{
        let reference = FIRDatabase.database().reference().child("messages")
        let childRef = reference.childByAutoId()
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let toId = user!.id!
        let timeStamp:NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text!, "toId": toId, "fromId": fromId,"timestamp":timeStamp]
        //childRef.updateChildValues(values)
        
        childRef.updateChildValues(values) { (error, ref) in
            if error != nil{
                print(error)
                return
            }
            
            self.inputTextField.text = nil
            
            let userMessagesRef = FIRDatabase.database().reference().child("user-messages").child(fromId)
            
            let messageId = childRef.key
            userMessagesRef.updateChildValues([messageId:1])
            
            
            let recepientRef = FIRDatabase.database().reference().child("user-messages").child(toId)
            recepientRef.updateChildValues([messageId:1])
            
        }
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    let cellId = "cellId"
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(cellId, forIndexPath: indexPath) as! ChatMessageCell
        
        let message = messages[indexPath.row]
        cell.textView.text = message.text
        
        setupCell(cell, message: message)
        //width modification
        cell.bubbleWidthAnchor?.constant = estimatedFrameForText(message.text!).width + 28
        
        return cell
    }
    
    private func setupCell(cell:ChatMessageCell, message:Message) {
    
        if let profileImageUrl = self.user?.profileImageUrl {
            cell.profileImageView.loadImageUsingCache(profileImageUrl)
    
        }
        if message.fromId == FIRAuth.auth()?.currentUser?.uid
        {
            //outgoing blue
            cell.bubbleView.backgroundColor = ChatMessageCell.blueColor
            cell.textView.textColor = UIColor.whiteColor()
            
            cell.profileImageView.hidden = true
            
            cell.bubbleViewRightAnchor?.active = true
            cell.bubbleViewLeftAnchor?.active = false
        }
        else{
            //incoming grey
            cell.bubbleView.backgroundColor = UIColor(r: 240, g: 240, b: 240)
            cell.textView.textColor = UIColor.blackColor()
            
            cell.profileImageView.hidden = false
            cell.bubbleViewRightAnchor?.active = false
            cell.bubbleViewLeftAnchor?.active = true
            
        }
    }
    
    private func estimatedFrameForText(text:String) -> CGRect{
        let size = CGSize(width: 200, height: 1000)
        let options = NSStringDrawingOptions.UsesFontLeading.union(.UsesLineFragmentOrigin)
        return NSString(string: text).boundingRectWithSize(size, options: options, attributes: [NSFontAttributeName:UIFont.systemFontOfSize(16)], context: nil)
    
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        var height:CGFloat = 80
        
        if let text = messages[indexPath.item].text{
            
            height = estimatedFrameForText(text).height + 20
            
        }
        
        return CGSize(width: view.frame.width, height: height)
    }
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
}
