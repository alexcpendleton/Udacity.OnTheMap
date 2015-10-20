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

public class NewLocationViewController : UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem?
    @IBOutlet weak var findEnteredLocationButton: UIButton?
    @IBOutlet weak var enteredLocationField: UITextField?
    public lazy var locator:Locator = {
        return Locator()
        }()
    
    public var useTestingDefaults = AppDelegate.useTestingDefaults
    
    // I feel like these strings should be in some sort of localizable thing
    // Does the course cover that?
    let nothingFoundMessage = "We couldn't find anything at that location.";
    
    @IBAction func findEnteredLocationPressed(sender: AnyObject?) {
        attemptToGeocode(enteredLocationField!.text!)
    }
    
    func attemptToGeocode(address:String) {
        if address.isEmpty {
            displayErrorMessage("Please enter a location to geocode.")
        } else {
            locator.geocode(address) { (placemark, error) -> Void in
                if error != nil {
                    self.displayGeocodeError(error!)
                } else {
                    if placemark?.count == 0 {
                        // I don't think this is something that can happen
                        // but it's covered for paranoia's sake
                        self.displayErrorMessage(self.nothingFoundMessage)
                    } else {
                        self.proceed(placemark!)
                    }
                }
            }
        }
    }
    
    func displayErrorMessage(message:String) {
        AppDelegate.alerter.showAlert(message, title: "Whoops", presentUsing: self)
    }
    
    func displayGeocodeError(error:NSError) {
        var message = "There was a problem when trying to geocode that location, sorry!"
        // Handle a few known error cases
        if error.code == CLError.GeocodeFoundNoResult.rawValue {
            message = nothingFoundMessage
        }
        displayErrorMessage(message)
        print(error.description)
    }
    
    func proceed(placemark:[CLPlacemark]) {
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

        navigationController?.pushViewController(toPresent, animated: true)
        //self.presentViewController(toPresent, animated: true, completion: nil)
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
        
        super.viewWillAppear(animated)
    }
}
