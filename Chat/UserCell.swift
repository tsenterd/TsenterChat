//
//  UserCell.swift
//  Chat
//
//  Created by Tsenter, David on 7/31/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
class UserCell: UITableViewCell {
    
    var message:Message?{
        didSet{
            setupNameAndProfileImage()
            detailTextLabel?.text = message?.text
            
            if let seconds = message?.timestamp?.doubleValue{
                let timestampDate = NSDate(timeIntervalSince1970: seconds)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "hh:mm:ss a"
                timeLabel.text = dateFormatter.stringFromDate(timestampDate)
            }
            
            
            
        }
    }
    
    private func setupNameAndProfileImage(){
        
        if let id = message?.chatPartnerId(){
            
            let ref = FIRDatabase.database().reference().child("users").child(id)
            
            ref.observeSingleEventOfType(.Value, withBlock: { (snapshot) in
                if let dict = snapshot.value as? [String:AnyObject]{
                    self.textLabel?.text = dict["name"] as? String
                    
                    if let profileImageUrl = dict["profileImageUrl"] as? String{
                        self.profileImageView.loadImageUsingCache(profileImageUrl)
                        
                    }
                    
                }
            })
            
        }
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 24
        imageView.layer.masksToBounds = true
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    let timeLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(12)
        label.textColor = UIColor.lightGrayColor()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        
        textLabel?.frame = CGRect(x: 64,y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64,y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .Subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        addSubview(timeLabel)
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor, constant: 8).active = true
        profileImageView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(48).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(48).active = true
        
        timeLabel.rightAnchor.constraintEqualToAnchor(self.rightAnchor).active = true
        timeLabel.topAnchor.constraintEqualToAnchor(self.topAnchor,constant: 18).active = true
        timeLabel.widthAnchor.constraintEqualToConstant(100).active = true
        timeLabel.heightAnchor.constraintEqualToAnchor(textLabel?.heightAnchor).active = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}