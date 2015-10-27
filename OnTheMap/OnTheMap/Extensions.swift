//
//  NSURLExtensions.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/7/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import MapKit

extension String {
    func isProbablyAValidUrl() -> Bool {
        if (self.isEmpty) {
            return false
        }
        
        let output = NSURL(string: self)
        if output == nil {
            return false
        }
        let host = output!.host
        if ((host == nil) || (host!.isEmpty)) {
            return false
        }
        let scheme = output!.scheme
        if (scheme.isEmpty) {
            return false
        }
        return true
    }
    
    func openUrl()->Bool {
        let app = UIApplication.sharedApplication()
        if self.isProbablyAValidUrl() {
            app.openURL(NSURL(string: self)!)
            return true
        }
        return false
    }
}

extension NSError {
    func isNetworkError()->Bool {
        return self.domain == NSURLErrorDomain
    }
}

extension NSDictionary {
    func getString(key:String, orValue:String = "")->String {
        return self[key] as? String ?? ""
    }
}

extension Double {
    func delay(closure:()->()) {
        dispatch_after(
            dispatch_time(
                DISPATCH_TIME_NOW,
                Int64(self * Double(NSEC_PER_SEC))
            ),
            dispatch_get_main_queue(), closure)
    }
}

extension StudentLocation {
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
        }
    }
}

extension MKMapView {
    func zoomToCoordinate(coordinate:CLLocationCoordinate2D, distance: CLLocationDistance = 6000) {
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        self.setCenterCoordinate(coordinate, animated: true)
        self.setRegion(region, animated: true)
    }
}