//
//  NSURLExtensions.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/7/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

extension String {
    func isProbablyAValidUrl() -> Bool {
        if (self.isEmpty) {
            return false
        }
        
        let output = NSURL(string: self)
        if output == nil {
            return false
        }
        let host = output!.host
        if ((host == nil) || (host!.isEmpty)) {
            return false
        }
        let scheme = output!.scheme
        if (scheme.isEmpty) {
            return false
        }
        return true
    }
    
    func openUrl()->Bool {
        let app = UIApplication.sharedApplication()
        if self.isProbablyAValidUrl() {
            app.openURL(NSURL(string: self)!)
            return true
        }
        return false
    }
}

extension NSError {
    func isNetworkError()->Bool {
        return self.domain == NSURLErrorDomain
    }
}

extension NSDictionary {
    func getString(key:String, orValue:String = "")->String {
        return self[key] as? String ?? ""
    }
}