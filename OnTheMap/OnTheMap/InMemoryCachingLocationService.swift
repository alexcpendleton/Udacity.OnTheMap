//
//  InMemoryCachingLocationService.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/28/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class InMemoryCachingLocationsService : StudentLocationsServiceable {
    init(backingSource:StudentLocationsServiceable) {
        rawService = backingSource
    }
    public var cached:[StudentLocation]? = nil
    var rawService: StudentLocationsServiceable
    
    public func clearCacheIfApplicable() {
        cached = nil
    }
    
    public func getLatest100(completionHandler: ([StudentLocation]?, NSError?) -> Void) {
        self.get(100, skip: nil, order: nil, completionHandler: completionHandler)
    }
    
    public func get(limit: Int?, skip: Int?, order: String?, completionHandler: ([StudentLocation]?, NSError?) -> Void) {
        if cached == nil {
            rawService.get(limit, skip: skip, order: order, completionHandler: { (locations, errors) -> Void in
                if locations != nil {
                    self.cached = locations!
                }
                completionHandler(self.cached, errors)
            })
        } else {
            completionHandler(cached, nil)
        }
    }
    
    public func create(location: StudentLocation, completionHandler: (StudentLocation?, NSError?) -> Void) {
        // Add it to the raw service, then put it at the beginning of the list
        rawService.create(location) { (created, error) -> Void in
            if created != nil {
                // If there is somehow nothing already in the cached list
                // then init it
                if self.cached == nil {
                    self.cached = [StudentLocation]()
                }
                self.cached?.insert(created!, atIndex: 0)
            }
            completionHandler(created, error)
        }
    }
}