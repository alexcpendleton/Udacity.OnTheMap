//
//  RawUdacityServices.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/20/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class RawUdacityServices : LoginServiceable  {
    
    private func makeApiCall(uri:String, bodyContent:AnyObject?, method:String, completionHandler:(NSDictionary?, NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: uri)!)
        let completeOnMainQueue:(NSDictionary?, NSError?)->Void = {
            let d = $0
            let e = $1
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(d, e)
            }
        }
        let completeWithError:(NSError)->Void = {
            completeOnMainQueue(nil, $0)
        }
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if bodyContent != nil {
            do {
                var jsonData: NSData!
                jsonData = try NSJSONSerialization.dataWithJSONObject(bodyContent!, options: NSJSONWritingOptions.PrettyPrinted)
                request.HTTPBody = jsonData
            } catch let error as NSError {
                completeWithError(error)
            }
        }
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(request) { data, response, error in
            let httpResponse = response as! NSHTTPURLResponse
            if error != nil { // Handle error…
                completeWithError(error!)
            } else {
                let newData = data!.subdataWithRange(NSMakeRange(5, data!.length - 5)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                if (httpResponse.statusCode == 200) {
                    do {
                        let results = try NSJSONSerialization.JSONObjectWithData(newData, options: []) as! NSDictionary
                        //print(results)
                        completeOnMainQueue(results, nil)
                    } catch let e2 as NSError {
                        completeWithError(e2)
                    }
                } else {
                    completeWithError(NSError(domain: "onthemap", code: httpResponse.statusCode, userInfo: ["httpResponse":httpResponse]))
                }
            }
        }
        task.resume()
        
    }
    
    public func attemptToLogin(credentials: (username: String, password: String), completionHandler: (LoginResults?, NSError?)->Void) {
        let bodyContent = [
            "udacity": [
                "username":credentials.username,
                "password":credentials.password
            ]
        ]
        makeApiCall("https://www.udacity.com/api/session",
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
}