//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/5/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//
import Foundation
import UIKit
import MapKit

public class MapViewController : UIViewController, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    var studentLocationService = {
        return AppDelegate.studentLocationService
    }()
    
    public override func viewWillAppear(animated: Bool) {
        addAnnotations()
        super.viewWillAppear(animated)
    }

    func addAnnotations() {
        map.addAnnotations(studentLocationService.get(nil, skip: nil, order: nil).map({ makeAnnotation($0) }))
    }
    
    func makeAnnotation(from:StudentLocation) -> MKPointAnnotation {
        let result = MKPointAnnotation()
        result.coordinate = CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude)
        result.title = from.firstName + " " + from.lastName
        result.subtitle = from.mediaURL
        return result
    }

}