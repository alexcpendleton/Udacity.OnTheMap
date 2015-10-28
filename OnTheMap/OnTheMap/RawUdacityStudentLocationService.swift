//
//  RawUdacityStudentLocationService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/22/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class RawUdacityStudentLocationService : StudentLocationsServiceable {
    let apiCaller = UdacityApiCaller()
    
    public func getLatest100(completionHandler:([StudentLocation]?, NSError?)->Void) {
        get(100, skip: nil, order: nil, completionHandler: completionHandler)
    }
    
    private func buildGetUri(limit: Int?, skip: Int?, order: String?) -> NSURL {
        var params = [NSURLQueryItem]()
        if limit != nil { params.append(NSURLQueryItem(name: "limit", value: limit?.description)) }
        if skip != nil { params.append(NSURLQueryItem(name: "skip", value: skip?.description)) }
        if order == nil {
            params.append(NSURLQueryItem(name: "order", value: "-updatedAt"))
        }
        
        let uri = NSURLComponents(string: "https://api.parse.com/1/classes/StudentLocation")
        uri?.queryItems = params
        return (uri?.URL!)!
    }
    
    public func get(limit: Int?, skip: Int?, order: String?, completionHandler:([StudentLocation]?, NSError?)->Void) {
        var results = [StudentLocation]()

        let uri = buildGetUri(limit, skip: skip, order: order).description
        apiCaller.makeApiCall(uri, bodyContent: nil, method: "GET", useParseHeaders: true) { (data, error) -> Void in
            if (data != nil) {
                let locations = data!["results"] as! NSArray
                for item in locations {
                    results.append(StudentLocation(fromDictionary: item as! NSDictionary))
                }
            }
            completionHandler(results, error)
        }
    }
    
    public func create(location: StudentLocation, completionHandler: (StudentLocation?, NSError?) -> Void) {
        let uri = "https://api.parse.com/1/classes/StudentLocation"
        apiCaller.makeApiCall(uri, bodyContent: location.toUdacityPostable(), method: "POST", useParseHeaders: true) { (data, error) -> Void in
            completionHandler(location, error)
        }
    }
}