//
//  HTTPClient.swift
//  App_Patron_MVC_Completo
//
//  Created by User on 21/12/15.
//  Copyright © 2015 iCologic. All rights reserved.
//

import UIKit

class HTTPClient {
    
    
    func getRequest(url: String) -> (AnyObject) {
        return NSData()
    }
    
    func postRequest(url: String, body: String) -> (AnyObject){
        return NSData()
    }
    
    func downloadImage(url: String) -> (UIImage) {
        let aUrl = NSURL(string: url)
        let data = NSData(contentsOfURL: aUrl!)
        let image = UIImage(data: data!)
        return image!
    }
    
}
