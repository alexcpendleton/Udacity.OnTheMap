//
//  RawUdacityServices.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/20/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation


public class RawUdacityServices : LoginServiceable, UserInfoServiceable {
    lazy var apiCaller = { UdacityApiCaller() }()
    
    public func attemptToLogin(credentials: (username: String, password: String), completionHandler: (LoginResults?, NSError?)->Void) {
        let bodyContent = [
            "udacity": [
                "username":credentials.username,
                "password":credentials.password
            ]
        ]
        apiCaller.makeApiCall("https://www.udacity.com/api/session",
            bodyContent: bodyContent, method: "POST") { (results, error) -> Void in
            if error != nil {
                completionHandler(LoginResults(success: false, sessionInfo: nil), error)
            } else {
                completionHandler(
                    LoginResults(success: true, sessionInfo: LoginSession(json: results!)
                ), error)
            }
        }
    }
    
    public func get(userID: String, completionHandler: (UserInfo?, NSError?) -> Void) {
        apiCaller.makeApiCall("https://www.udacity.com/api/users/\(userID)", bodyContent: nil, method: "GET") { (data, error) -> Void in
            
            var info: UserInfo?
            if error == nil {
                info = UserInfo(fromDictionary: data!)
            }
            completionHandler(info, error)
        }
    }

}