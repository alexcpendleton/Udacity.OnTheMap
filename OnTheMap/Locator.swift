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
    public var artificialDelay: Double = 0
    public func geocode(fromEntered:String, completionHandler: CLGeocodeCompletionHandler) {
        artificialDelay.delay {
            let geocoder = CLGeocoder()
            geocoder.geocodeAddressString(fromEntered, completionHandler: completionHandler)
        }
    }
}