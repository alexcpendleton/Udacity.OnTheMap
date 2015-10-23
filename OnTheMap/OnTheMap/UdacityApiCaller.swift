//
//  UdacityApiCaller.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/22/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class UdacityApiCaller {
    public func makeApiCall(uri:String, bodyContent:AnyObject?, method:String, useParseHeaders:Bool = false, completionHandler:(NSDictionary?, NSError?)->Void) {
        let request = NSMutableURLRequest(URL: NSURL(string: uri)!)
        let completeOnMainQueue:(NSDictionary?, NSError?)->Void = {
            let d = $0
            let e = $1
            //NSOperationQueue.mainQueue().addOperationWithBlock {
                completionHandler(d, e)
            //}
        }
        let completeWithError:(NSError)->Void = {
            completeOnMainQueue(nil, $0)
        }
        request.HTTPMethod = method
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        if useParseHeaders {
            request.addValue("QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", forHTTPHeaderField: "X-Parse-Application-Id")
            request.addValue("QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY", forHTTPHeaderField: "X-Parse-REST-API-Key")
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
}