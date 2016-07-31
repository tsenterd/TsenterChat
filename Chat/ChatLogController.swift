//
//  ChatLogController.swift
//  Chat
//
//  Created by Tsenter, David on 7/30/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
class ChatLogController: UICollectionViewController, UITextFieldDelegate {
    
    
    var user:User? {
        didSet{
            navigationItem.title = user?.name
        }
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
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        
        setupInputComponents()
    }
    
    func setupInputComponents(){
    
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
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
        let reference = FIRDatabase.database().reference().child("messages")
        let childRef = reference.childByAutoId()
        let fromId = FIRAuth.auth()!.currentUser!.uid
        let toId = user!.id!
        let timeStamp:NSNumber = Int(NSDate().timeIntervalSince1970)
        let values = ["text":inputTextField.text!, "toId": toId, "fromId": fromId,"timestamp":timeStamp]
        childRef.updateChildValues(values)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        handleSend()
        return true
    }
    
}
