//
//  UdacityApiCaller.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/22/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class UdacityApiCaller {
    public func makeApiCall(uri:String, bodyContent:AnyObject?,
        method:String, useParseHeaders:Bool = false,
        timeoutIntervalInSeconds:Double = 5.0,
        completionHandler:(NSDictionary?, NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: uri)!)
        let completeOnMainQueue:(NSDictionary?, NSError?)->Void = {
            let d = $0
            let e = $1
            NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(d, e)
            }
        }
        let completeWithError:(NSError)->Void = {
            print("completing with error:")
            print($0)
            completeOnMainQueue(nil, $0)
        }
        var weirdSecurityBufferLength = 5
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.timeoutInterval = timeoutIntervalInSeconds
            
        if useParseHeaders {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
            weirdSecurityBufferLength = 0
        }
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
            if error != nil { // Handle error…
                completeWithError(error!)
            } else {
                let httpResponse = response as! NSHTTPURLResponse
                let newData = data!.subdataWithRange(NSMakeRange(weirdSecurityBufferLength, data!.length - weirdSecurityBufferLength)) /* subset response data! */
                print(NSString(data: newData, encoding: NSUTF8StringEncoding))
                // All 200s are OK! (Submitting locations returns a 201, for instance)
                if (200...299 ~= httpResponse.statusCode) {
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
}