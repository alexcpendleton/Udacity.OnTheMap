
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
    var session: (id:String, expiration:NSDate) = ("", NSDate())
}