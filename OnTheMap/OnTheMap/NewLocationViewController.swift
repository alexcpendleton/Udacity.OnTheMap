//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/16/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

public class NewLocationViewController : UIViewController, KeyboardManagerDelegate {
    @IBOutlet weak var cancelButton: UIBarButtonItem?
    @IBOutlet weak var findEnteredLocationButton: UIButton?
    @IBOutlet weak var enteredLocationField: UITextField?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    public lazy var locator:Locator = { return Locator() }()
    
    public var useTestingDefaults = AppDelegate.useTestingDefaults
    var keyboardManager:KeyboardManager!
    
    // I feel like these strings should be in some sort of localizable thing
    // Does the course cover that?
    let nothingFoundMessage = "We couldn't find anything at that location.";
    
    @IBAction func findEnteredLocationPressed(sender: AnyObject?) {
        attemptToGeocode(enteredLocationField!.text!)
    }
    
    func applyGeocodingStyles() {
        activityIndicator?.startAnimating()
        enteredLocationField?.enabled = false
        findEnteredLocationButton?.enabled = false
    }
    
    func applyGeocodingFinishedStyles() {
        activityIndicator?.stopAnimating()
        enteredLocationField?.enabled = true
        findEnteredLocationButton?.enabled = true
    }
    
    func attemptToGeocode(address:String) {
        if address.isEmpty {
            displayErrorMessage("Please enter a location to geocode.")
        } else {
            applyGeocodingStyles()
            locator.geocode(address) { (placemark, error) -> Void in
                if error != nil {
                    self.displayGeocodeError(error!)
                } else {
                    if placemark == nil || placemark?.count == 0 {
                        // I don't think this is something that can happen
                        // but it's covered for paranoia's sake
                        self.displayErrorMessage(self.nothingFoundMessage)
                    } else {
                        self.proceed(placemark!, address: address)
                    }
                }
                self.applyGeocodingFinishedStyles()
            }
        }
    }
    
    func displayErrorMessage(message:String) {
        AppDelegate.alerter.showAlert(message, title: "Whoops", presentUsing: self)
    }
    
    func displayGeocodeError(error:NSError) {
        var message = "Sorry, there was a problem when trying to geocode that location."
        // Handle a few known error cases
        // "No result" (code 8) also occurs when there's bad network connectivity
        if error.code == CLError.GeocodeFoundNoResult.rawValue {
            message = nothingFoundMessage
        }
        if error.isNetworkError() {
            message = "Sorry, there was an error connecting to the geocoding server."
        }
        displayErrorMessage(message)
        print(error.description)
    }
    
    func proceed(placemark:[CLPlacemark], address: String) {
        print("geocoded successfully")
        
        /* 
        Coming from a web dev background, creating and instantiating a whole
        new view controller seems sort of bulky and redundant. Why not just
        swap the "visible" elements for visually similar layouts? I'm having
        trouble figuring out the best way to share identical (or very similar)
        elements among ViewControllers, particularly navigation bars. 
        
        Is there something else I should be doing, or is this just the way
        of the world in iOS? Would swapping out nibs/xibs be better?
        */
        let toPresent = storyboard?.instantiateViewControllerWithIdentifier("MapNewLocationViewController") as! MapNewLocationViewController
        
        // For the sake of simplicity we'll take the first placemark and
        // hopefully that's good enough
        toPresent.chosenLocation = placemark.first!
        toPresent.chosenMapString = address

        navigationController?.pushViewController(toPresent, animated: true)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        if (useTestingDefaults) {
            //enteredLocationField?.text = "1 Infinite Loop, Cupertino, CA"
            enteredLocationField?.text = "Nashua, NH"
        }
        
        navigationItem.hidesBackButton = true
        navigationController?.navigationBarHidden = false
        findEnteredLocationButton?.setTitle("", forState: UIControlState.Disabled)
        activityIndicator?.color = view.tintColor
        
        super.viewWillAppear(animated)
    }
    
    public override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        keyboardManager = KeyboardManager(inViewController: self, delegate: self)
        keyboardManager.register()
    }
    
    public override func viewWillDisappear(animated: Bool) {
        keyboardManager.unregister()
        super.viewWillDisappear(animated)
    }
    
    public func keyboardWillHide(keyboardHeight: CGFloat) {
        // Move the submit button up above the keyboard
        view.frame.origin.y += keyboardHeight
    }
    
    public func keyboardWillShow(keyboardHeight: CGFloat) {
        view.frame.origin.y -= keyboardHeight
    }
}
