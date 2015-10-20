//
//  UserInfoServiceable.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/19/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol UserInfoServiceable {
    func get(userID: String, completionHandler: (UserInfo?, NSError?)->Void)
}