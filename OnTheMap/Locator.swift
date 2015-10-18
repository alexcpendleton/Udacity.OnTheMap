//
//  Locator.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/18/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import CoreLocation

public class Locator {
    public func geocode(fromEntered:String, completionHandler: CLGeocodeCompletionHandler) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(fromEntered, completionHandler: completionHandler)
    }
}
