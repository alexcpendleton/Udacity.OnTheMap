//
//  LoginServiceable.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol LoginServiceable {
    func attemptToLogin(credential: LoginCreditable, completionHandler: (LoginResults?, NSError?)->Void)
    func logout(session: LoginSession, completionHandler: (NSError?)->Void)
}

public class LoginResults {
    init(success:Bool, sessionInfo:LoginSession?) {
        self.successful = success
        self.session = sessionInfo
    }
    var successful:Bool
    var session:LoginSession?
}

public protocol LoginCreditable {
    func toPostable()->AnyObject
}

public class UsernamePasswordCredential : LoginCreditable {
    let username: String
    let password: String
    init(username u: String, password p: String) {
        username = u
        password = p
    }
    public func toPostable() -> AnyObject {
        return [
            "udacity": [
                "username":username,
                "password":password
            ]
        ]
    }
}

public class FacebookCredential : LoginCreditable {
    let token: String
    init(token t: String) {
        token = t
    }
    public func toPostable() -> AnyObject {
        return [
            "facebook_mobile": [
                "access_token": token
            ]
        ]
    }
}