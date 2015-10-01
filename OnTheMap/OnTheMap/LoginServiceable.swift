//
//  LoginServiceable.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol LoginServiceable {
    func attemptToLogin(credentials:(username:String, password:String)) -> (successful:Bool, session:LoginSession)
}