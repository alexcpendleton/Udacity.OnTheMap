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
    public var first_name = ""
    public var last_name = ""
    public var website_url = ""
}