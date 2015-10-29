//
//  FakeStudentLocationService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/5/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class FakeStudentLocationService : StudentLocationsServiceable {
    var allLocations: [StudentLocation]!
    var simulatedGetDelay: Double = 1.5
    var simulatedCreateDelay: Double = 1.0
    
    public init() {
        allLocations = self.makeFakeData(10)
    }
    
    public func clearCacheIfApplicable() {
        // Not applicable
    }
    
    public func getLatest100(completionHandler:([StudentLocation]?, NSError?)->Void) {
        return get(100, skip: nil, order: nil, completionHandler: completionHandler)
    }
    
    public func get(limit: Int?, skip: Int?, order: String?, completionHandler:([StudentLocation]?, NSError?)->Void) {
        simulatedGetDelay.delay { completionHandler(self.allLocations, nil) }
    }
    
    public func create(location: StudentLocation, completionHandler:(StudentLocation?, NSError?)->Void) {
        allLocations.append(location)
        simulatedCreateDelay.delay { completionHandler(location, nil) }
    }
    
    public func makeFakeData(count:Int) -> [StudentLocation] {
        var results = [StudentLocation]()
        
        for index in 1...count {
            var item = StudentLocation()
            item.acl = nil
            item.createdAt = NSCalendar.currentCalendar().dateByAddingUnit(NSCalendarUnit.Day, value: index * -1, toDate: NSDate(), options: NSCalendarOptions(rawValue: 0))
            item.firstName = "Student"
            item.lastName = "Location \(index)"
            let coords = makeCoords()
            item.latitude = coords.0
            item.longitude = coords.1
            item.mapString = "Map String #\(index)"
            item.mediaURL = "http://whatever.com/"
            results.append(item)
        }
        return results
    }
    
    func makeCoords() -> (Double, Double) {
        /* 38.376115, -101.953125 */
        let spread = 15.00
        let startLat = 38.376115
        let startLon = -101.953125
        
        
        return (
            Random.within(startLat-spread...startLat+spread),
            Random.within(startLon-spread...startLon+spread)
        )
    }
}