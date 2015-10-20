//
//  FakeUserInfoService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/19/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class FakeUserInfoService : UserInfoServiceable {
    public func get(userID: String, completionHandler: (UserInfo?, NSError?)->Void) {
        completionHandler(UserInfo(firstName: "Fakerton", lastName: "McNotReal", website: "http://www.udacity.com"), nil)
    }
}
