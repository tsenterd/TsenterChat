//
//  Message.swift
//  Chat
//
//  Created by Tsenter, David on 7/31/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit
import Firebase
class Message: NSObject {
    var fromId:String?
    var text:String?
    var timestamp:NSNumber?
    var toId:String?
 
    func chatPartnerId() -> String?{
        if fromId == FIRAuth.auth()?.currentUser?.uid{
            return toId
        }else{
            return fromId
        }
    
    }
}
