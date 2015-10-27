//
//  StudentLocation.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/5/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class StudentLocation : CustomStringConvertible {
    var objectId: String = ""
    var uniqueKey: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var mapString: String = ""
    var mediaURL: String = ""
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    var createdAt: NSDate?
    var updatedAt: NSDate?
    var acl: NSObject?
    
    public var description: String { get { return firstName + " " + lastName } }
    
    init(){}
    init(fromDictionary:NSDictionary) {
        objectId = fromDictionary.getString("objectId")
        uniqueKey = fromDictionary.getString("uniqueKey")
        firstName = fromDictionary.getString("firstName")
        lastName = fromDictionary.getString("lastName")
        mapString = fromDictionary.getString("mapString")
        mediaURL = fromDictionary.getString("mediaURL")
        latitude = fromDictionary["latitude"] as! Double
        longitude = fromDictionary["longitude"] as! Double
        // The rubric says to ignore dates and acl, so I did
        
        createdAt = parseDate(fromDictionary["createdAt"] as! String)
    }
    
    var dateParser: NSDateFormatter = {
        var result = NSDateFormatter()
        result.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.z'Z'"
        return result
    }()
    
    func parseDate(toParse:String) -> NSDate? {
        return dateParser.dateFromString(toParse)
    }
    
    func toUdacityPostable()->[String : AnyObject] {
        var results = [String:AnyObject]()
        results["objectId"] = objectId
        results["uniqueKey"] = uniqueKey
        results["firstName"] = firstName
        results["lastName"] = lastName
        results["mapString"] = mapString
        results["mediaURL"] = mediaURL
        results["latitude"] = latitude
        results["longitude"] = longitude
        return results
    }
}