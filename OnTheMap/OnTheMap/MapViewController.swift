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

public class MapViewController : UIViewController, MKMapViewDelegate{
    @IBOutlet weak var map: MKMapView!
    
    var studentLocationService = {
        return AppDelegate.studentLocationService
    }()
    var currentLocations:[StudentLocation]!
    
    public override func viewWillAppear(animated: Bool) {
        map.delegate = self
        
        if currentLocations == nil {
            currentLocations = studentLocationService.getLatest100()
        }
        
        addAnnotations()
        super.viewWillAppear(animated)
    }

    func addAnnotations() {
        map.addAnnotations(currentLocations.map({ makeAnnotation($0) }))
    }
    
    func makeAnnotation(from:StudentLocation) -> MKPointAnnotation {
        let result = MKPointAnnotation()
        result.coordinate = CLLocationCoordinate2D(latitude: from.latitude, longitude: from.longitude)
        result.title = from.firstName + " " + from.lastName
        result.subtitle = from.mediaURL
        return result
    }
    
    public func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = UIColor.redColor()
            pinView!.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    public func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            if let toOpen = view.annotation?.subtitle! {
                if toOpen.isProbablyAValidUrl() {
                    app.openURL(NSURL(string: toOpen)!)
                }
            }
        }
    }
}