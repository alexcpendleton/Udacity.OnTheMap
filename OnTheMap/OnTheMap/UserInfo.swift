//
//  UserInfo.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/19/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class UserInfo {
    init(){}
    init(firstName:String, lastName:String, website:String = "") {
        first_name = firstName
        last_name = lastName
        website_url = website
    }
    init(fromDictionary:NSDictionary) {
        // There must be a better way to do deserialize JSON
        // Don't be surprised if other classes get deserialized
        // and inferred through some third-party library
        let user = fromDictionary["user"] as! NSDictionary
        first_name = (user["first_name"] as? String) ?? ""

        last_name = (user["last_name"] as? String) ?? ""

        website_url = (user["website_url"] as? String) ?? ""
    }
    public var first_name = ""
    public var last_name = ""
    public var website_url = ""
}