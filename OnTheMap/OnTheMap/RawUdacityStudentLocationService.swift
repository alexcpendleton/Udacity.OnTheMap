//
//  RawUdacityStudentLocationService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/22/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class RawUdacityStudentLocationService : StudentLocationsServiceable {
    /*

func getLatest100()->[StudentLocation]
func get(limit:Int?, skip:Int?, order:String?)->[StudentLocation]
func create(location: StudentLocation, completionHandler:(StudentLocation?, NSError?)->Void)
*/
    let apiCaller = UdacityApiCaller()
    
    public func getLatest100() -> [StudentLocation] {
        return get(100, skip: nil, order: nil)
    }
    
    public func get(limit: Int?, skip: Int?, order: String?) -> [StudentLocation] {
        var results = [StudentLocation]()
        let uri = "https://api.parse.com/1/classes/StudentLocation?limit=\(limit)&skip=\(skip)&order=\(order)"
        apiCaller.makeApiCall(uri, bodyContent: nil, method: "GET") { (data, error) -> Void in
            // We're ignoring errors here for now I guess
            // Just return an empty array if it errors
            if (data != nil) {
                let locations = data!["results"] as! NSArray
                for item in locations {
                    results.append(StudentLocation(fromDictionary: item as! NSDictionary))
                }
            }
        }
        return results
    }
    
    public func create(location: StudentLocation, completionHandler: (StudentLocation?, NSError?) -> Void) {
    }
}