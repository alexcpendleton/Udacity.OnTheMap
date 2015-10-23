//
//  LoginServiceable.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol LoginServiceable {
    func attemptToLogin(credentials:(username:String, password:String), completionHandler: (LoginResults?, NSError?)->Void)
}

public class LoginResults {
    init(success:Bool, sessionInfo:LoginSession?) {
        self.successful = success
        self.session = sessionInfo
    }
    var successful:Bool
    var session:LoginSession?
}