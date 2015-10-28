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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var previewButton: UIButton!
    
    var chosenLocation: CLPlacemark!
    var chosenMapString: String!
    var userInfo: UserInfo!
    let locationSelectionManager = { AppDelegate.locationSelectionManager }()
    
    var sessionManager = { AppDelegate.sessionManager }()
    
    internal var studentLocationService = {
        return AppDelegate.studentLocationService
    }()
    
    public override func viewWillAppear(animated: Bool) {
        // Show the back button on this one, so the user
        // can re-enter a location if desired. Cancel
        // will quit out entirely.
        navigationItem.hidesBackButton = false
        let iconTintColor = self.view.tintColor
        previewButton.tintColor = iconTintColor
        activityIndicator.color = iconTintColor
        
        submitButton.setTitle("", forState: UIControlState.Disabled)
        
        if userInfo == nil {
            userInfo = sessionManager.currentUserData!
        }
        
        if !userInfo.website_url.isEmpty {
            mediaUrlField.text = userInfo.website_url
        }
        
        displayLocation()
        
        super.viewWillAppear(animated)
    }
    
    @IBAction func submitPressed(sender:UIButton?) {
        attemptToProceed()
    }
    
    @IBAction func cancelPressed(sender:UIButton?) {
        popBackToTabController()
    }
    
    func popBackToTabController() {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    func applyWaitingStyles() {
        activityIndicator.startAnimating()
        submitButton.enabled = false
    }
    
    func applyWaitingFinishedStyles() {
        activityIndicator.stopAnimating()
        submitButton.enabled = true
    }
    
    func validateBeforeSubmit() -> Bool {
        let badUrlMessage = "Please enter a media URL."
        let mediaUrl = mediaUrlField.text!
        if mediaUrl.isEmpty {
            displayErrorMessage(badUrlMessage)
            return false
        }
        if !mediaUrl.isProbablyAValidUrl() {
            displayErrorMessage(badUrlMessage)
            return false
        }
        return true
    }
    
    func attemptToProceed() {
        let mediaUrl = mediaUrlField.text!
        
        let isValid = validateBeforeSubmit()
        if isValid {
            let coordinate = getChosenCoordinate()
            var filled = StudentLocation()
            filled.firstName = userInfo.first_name
            filled.lastName = userInfo.last_name
            filled.latitude  = coordinate.latitude
            filled.longitude = coordinate.longitude
            filled.mediaURL = mediaUrl
            filled.mapString = chosenMapString
            filled.uniqueKey = sessionManager.currentSession!.account.key
            
            applyWaitingStyles()
            studentLocationService.create(filled, completionHandler: { (created, error) -> Void in
                if error != nil {
                    self.displayErrorMessage("Sorry, there was a problem submitting your location.")
                    print(error)
                } else {
                    self.locationSelectionManager.push(created!)
                    self.proceed()
                }
                self.applyWaitingFinishedStyles()
            })
        }
    }
    
    func proceed() {
        popBackToTabController()
    }
    
    func displayErrorMessage(message:String) {
        AppDelegate.alerter.showAlert(message, title: "", presentUsing: self)
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
        map.zoomToCoordinate(coordinate)
    }
    
    func annotateChosenLocation() {
        let result = MKPointAnnotation()
        result.coordinate = getChosenCoordinate()
        map.addAnnotation(result)
    }
    
    @IBAction func previewButtonPressed() {
        preview(mediaUrlField.text!)
    }
    
    func preview(uri:String) {
        uri.openUrl()
    }
}