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
    
    public init() {
        allLocations = self.makeFakeData(500)
    }
    
    public func get(limit: Int?, skip: Int?, order: String?) -> [StudentLocation] {
        return allLocations
    }
    
    public func create(location: StudentLocation) {
        allLocations.append(location)
    }
    
    public func makeFakeData(count:Int) -> [StudentLocation] {
        var results = [StudentLocation]()
        
        for index in 1...count {
            let item = StudentLocation()
            item.acl = nil
            item.createdAt = NSDate()
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