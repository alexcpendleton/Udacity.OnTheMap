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
    
    public private(set) var currentSession: LoginSession?
    public private(set) var currentUserData: UserInfo?
    
    public func login(credentials: LoginCreditable, completionHandler:(SessionManager?, NSError?)->Void) {
        let completeWithError: (NSError?) -> Void = {
            completionHandler(nil, $0)
        }
        // Not sure that I like these deeply nested completion handlers.
        // The refactorings I can think of don't look any better in my head.
        loginService.attemptToLogin(credentials) { (ls, err1) -> Void in
            if err1 != nil {
                completeWithError(err1)
            } else {
                let lss = ls?.session
                self.userInfoService.get((lss?.account.key)!, completionHandler: { (uinfo, err2) -> Void in
                    if err2 != nil {
                        completeWithError(err2)
                    } else {
                        self.currentSession = lss
                        self.currentUserData = uinfo
                        completionHandler(self, nil)
                    }
                })
            }
        }
    }
    
    public func clearSessionState(completionHandler:()->()) {
        // Clear our own state
        self.currentSession = nil
        self.currentUserData = nil
        // Facebook won't throw any exceptions if it doesn't
        // have a session to log out, so we can call it safely
        // regardless of whether we even have a Facebook session
        FBSDKLoginManager().logOut()
        completionHandler()
    }
    
    public func logout(completionHandler:(AnyObject?, NSError?)->Void) {
        let clearAndComplete:(NSError?)->() = {
            let e = $0
            self.clearSessionState({ () -> () in
                completionHandler(self, e)
            })
        }
        if currentSession != nil {
            loginService.logout(currentSession!) {
                clearAndComplete($0)
            }
        } else {
            clearAndComplete(nil)
        }
    }
}
