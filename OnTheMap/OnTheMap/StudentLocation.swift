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
    
}