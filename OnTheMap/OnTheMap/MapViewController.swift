//
//  MapViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/5/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//
// Non-Udacity-supplied icons come from: https://icons8.com/

import Foundation
import UIKit
import MapKit

public class MapViewController : StudentLocationsViewControllerBase, MKMapViewDelegate {
    @IBOutlet weak var map: MKMapView!
    
    let locationSelectionManager = { AppDelegate.locationSelectionManager }()
    
    public override func viewWillAppear(animated: Bool) {
        map?.delegate = self
        super.viewWillAppear(animated)
    }
    
    public func zoomTo(location: StudentLocation) {
        map.zoomToCoordinate(location.coordinate)
    }
    
    public func showAnnotation(location: StudentLocation) {
        let coordinate = location.coordinate
        let matchedAnnotation = map.annotations.filter {
            return $0.coordinate.latitude == coordinate.latitude
                && $0.coordinate.longitude == coordinate.longitude
        }.first
        if matchedAnnotation != nil {
            map.selectAnnotation(matchedAnnotation!, animated: true)
        }
    }
    
    public override func currentLocationsUpdated() {
        removeAnnotations()
        addAnnotations()
        focusAnnotationForCurrentLocation()
    }
    
    func focusAnnotationForCurrentLocation() {
        let locationToSelect = locationSelectionManager.pop()
        if locationToSelect != nil {
            zoomTo(locationToSelect!)
            showAnnotation(locationToSelect!)
        }
    }

    func removeAnnotations() {
        // http://stackoverflow.com/a/10867625/21201
        map!.removeAnnotations(map!.annotations.filter { $0 !== map!.userLocation })
    }
    func addAnnotations() {
        map?.addAnnotations(currentLocations.map({ makeAnnotation($0) }))
    }
    
    func makeAnnotation(from:StudentLocation) -> MKPointAnnotation {
        let result = MKPointAnnotation()
        result.coordinate = from.coordinate
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
            if let toOpen = view.annotation?.subtitle! {
                toOpen.openUrl()
            }
        }
    }
}