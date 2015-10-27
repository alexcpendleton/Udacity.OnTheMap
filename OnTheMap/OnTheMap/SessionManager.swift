//
//  SessionManager.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/26/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class SessionManager {
    var loginService: LoginServiceable
    var userInfoService: UserInfoServiceable
    
    init(login: LoginServiceable, users: UserInfoServiceable) {
        loginService = login
        userInfoService = users
    }
    
    var loginSession: LoginSession?
    var userInfo: UserInfo?
    
    func login(credentials: LoginCreditable, completionHandler:(AnyObject?, NSError?)->Void) {
        let completeWithError: (NSError?) -> Void = {
            completionHandler(nil, $0)
        }
        loginService.attemptToLogin(credentials) { (ls, err1) -> Void in
            if err1 != nil {
                completeWithError(err1)
            } else {
                let lss = ls?.session
                self.userInfoService.get((lss?.account.key)!, completionHandler: { (uinfo, err2) -> Void in
                    if err2 != nil {
                        completeWithError(err2)
                    } else {
                        self.loginSession = lss
                        self.userInfo = uinfo
                        completionHandler(self, nil)
                    }
                })
            }
        }
    }
}
