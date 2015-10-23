
//
//  LoginSession.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class LoginSession {
    var account: (registered:Bool, key:String) = (false, "")
    var session: (id:String, expiration:NSDate?) = ("", NSDate())
    
    init(){}
    init(json:NSDictionary) {
        let acct = json["account"]!
        let ses = json["session"]!
        account.registered = acct["registered"] as! Bool
        account.key = acct["key"] as! String
        session.id = ses["id"] as! String
        //let dateFormatter = NSDateFormatter()
        // This keeps breaking and the docs say not to worry about parsing dates...
        // Hopefully this gets covered
        //2015-05-10T16:48:30.760460Z
        session.expiration = nil // dateFormatter.dateFromString(ses["expiration"] as! String)!
    }
}