//
//  FakeSessionService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class FakeSessionService : LoginServiceable {
    public var shouldImitateSuccess = true
    public func attemptToLogin(credentials: (username: String, password: String)) -> LoginResults {
        if shouldImitateSuccess {
            let session = LoginSession()
            session.account = (true, "90210")
            session.session = ("session123", NSDate(timeIntervalSinceNow: 60000))
        
            return LoginResults(success: true, sessionInfo: session)
        }
        return LoginResults(success: false, sessionInfo: nil)
    }
}