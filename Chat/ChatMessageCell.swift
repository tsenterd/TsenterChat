//
//  ChatMessageCell.swift
//  Chat
//
//  Created by Tsenter, David on 7/31/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var bubbleWidthAnchor:NSLayoutConstraint?
    var bubbleViewRightAnchor:NSLayoutConstraint?
    var bubbleViewLeftAnchor:NSLayoutConstraint?
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFontOfSize(16)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.backgroundColor = UIColor.clearColor()
        tv.textColor = .whiteColor()
        tv.editable = false
        return tv
        
    }()
    static let blueColor = UIColor(r: 0, g: 137, b: 249)
    
    
    let bubbleView:UIView = {
        let view = UIView()
        view.backgroundColor = blueColor
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 16
        view.layer.masksToBounds = true
        return view
    }()
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 16
        imageView.contentMode = .ScaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(textView)
        addSubview(profileImageView)
        
        bubbleViewRightAnchor = bubbleView.rightAnchor.constraintEqualToAnchor(self.rightAnchor,constant: -8)
        bubbleViewRightAnchor?.active = true
        
        bubbleViewLeftAnchor = bubbleView.leftAnchor.constraintEqualToAnchor(profileImageView.rightAnchor,constant: 8)
        
        
        bubbleView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        bubbleView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        bubbleWidthAnchor =  bubbleView.widthAnchor.constraintEqualToConstant(200)
        bubbleWidthAnchor?.active = true
        
        textView.leftAnchor.constraintEqualToAnchor(bubbleView.leftAnchor, constant: 8).active = true
        textView.topAnchor.constraintEqualToAnchor(self.topAnchor).active = true
        textView.rightAnchor.constraintEqualToAnchor(bubbleView.rightAnchor).active = true
        textView.heightAnchor.constraintEqualToAnchor(self.heightAnchor).active = true
        
        profileImageView.leftAnchor.constraintEqualToAnchor(self.leftAnchor,constant: 8).active = true
        profileImageView.bottomAnchor.constraintEqualToAnchor(self.bottomAnchor).active = true
        profileImageView.widthAnchor.constraintEqualToConstant(32).active = true
        profileImageView.heightAnchor.constraintEqualToConstant(32).active = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}


