//
//  MapNewLocationViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/19/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import MapKit

public class MapNewLocationViewController : UIViewController {
    let useTestingDefaults = AppDelegate.useTestingDefaults
    
    @IBOutlet weak var mediaUrlField: UITextField!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var submitButton: UIButton!
    
    var chosenLocation: CLPlacemark!
    var chosenMapString: String!
    var userInfo: UserInfo!
    
    // Makes this injectable but defaults to current session variable value
    internal var userKey = {
        return AppDelegate.currentSession!.account.key
    }()
    
    internal var studentLocationService = {
        return AppDelegate.studentLocationService
        }()
    
    @IBAction func submitPressed(sender:UIButton?) {
        attemptToProceed()
    }
    
    @IBAction func cancelPressed(sender:UIButton?) {
        popBackToTabController()
    }
    
    func popBackToTabController() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func validateBeforeSubmit() -> Bool {
        let mediaUrl = mediaUrlField.text!
        if mediaUrl.isEmpty {
            displayErrorMessage("Please enter a media URL.")
            return false
        }
        if !mediaUrl.isProbablyAValidUrl() {
            displayErrorMessage("Please enter a valid URL.")
            return false
        }
        return true
    }
    
    func attemptToProceed() {
        let mediaUrl = mediaUrlField.text!
        
        let isValid = validateBeforeSubmit()
        if isValid {
            let coordinate = getChosenCoordinate()
            let filled = StudentLocation()
            filled.firstName = userInfo.first_name
            filled.lastName = userInfo.last_name
            filled.latitude  = coordinate.latitude
            filled.longitude = coordinate.longitude
            filled.mediaURL = mediaUrl
            filled.mapString = chosenMapString
            filled.uniqueKey = userKey
            
            studentLocationService.create(filled, completionHandler: { (created, error) -> Void in
                if error != nil {
                    self.displayErrorMessage("Sorry, there was a problem submitting your location.")
                    print(error)
                } else {
                    self.proceed()
                }
                
            })
        }
    }
    
    func proceed() {
        popBackToTabController()
    }
    
    func displayErrorMessage(message:String) {
        AppDelegate.alerter.showAlert(message, title: "Whoops", presentUsing: self)
    }
    
    func getChosenCoordinate() -> CLLocationCoordinate2D {
        return chosenLocation!.location!.coordinate
    }
    
    public func displayLocation() {
        annotateChosenLocation()
        centerToChosenLocation()
    }
    
    func centerToChosenLocation() {
        let coordinate = getChosenCoordinate()
        let distance = CLLocationDistance(floatLiteral: 5000)
        let region = MKCoordinateRegionMakeWithDistance(coordinate, distance, distance)
        map.setCenterCoordinate(coordinate, animated: true)
        map.setRegion(region, animated: true)
    }
    
    func annotateChosenLocation() {
        let result = MKPointAnnotation()
        result.coordinate = getChosenCoordinate()
        map.addAnnotation(result)
    }
    
    public override func viewWillAppear(animated: Bool) {
        // Show the back button on this one, so the user
        // can re-enter a location if desired. Cancel
        // will quit out entirely.
        navigationItem.hidesBackButton = false
        if userInfo == nil {
            userInfo = AppDelegate.currentUser!
        }
        
        if !userInfo.website_url.isEmpty {
            mediaUrlField.text = userInfo.website_url
        }
        
        displayLocation()
        
        super.viewWillAppear(animated)
    }
}