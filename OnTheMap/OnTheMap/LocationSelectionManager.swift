//
//  LocationSelectionManager.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/26/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public class LocationSelectionManager {
    // Handles the one-time selection of a student location
    // on the main MapViewController without having to know about it
    
    private var selected: StudentLocation?
    public func push(location: StudentLocation) {
        selected = location
    }
    
    public func pop() -> StudentLocation? {
        let result = selected
        selected = nil
        return result
    }
}