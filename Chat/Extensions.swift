//
//  Extensions.swift
//  Chat
//
//  Created by Tsenter, David on 7/30/16.
//  Copyright © 2016 Tsenter, David. All rights reserved.
//

import UIKit

let imageCache = NSCache()

extension UIImageView{

    func loadImageUsingCache(urlstring:String){
        
        self.image = nil
        
        //check cache for image before downloading it
        
        if let cachedImage = imageCache.objectForKey(urlstring)as? UIImage{
        
            self.image = cachedImage
            return
        }
        
        
        let url = NSURL(string: urlstring)
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error)
                return
            }
            dispatch_async(dispatch_get_main_queue(), {
                
                if let downloadedImage = UIImage(data:data!){
                    imageCache.setObject(downloadedImage, forKey: urlstring)
                    self.image = downloadedImage
                
                }
        
            })
            
        }).resume()
    
    }
}


