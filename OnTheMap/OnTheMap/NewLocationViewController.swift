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
    
    @IBAction func findEnteredLocationPressed(sender: AnyObject?) {
        attemptToGeocode(enteredLocationField!.text!)
    }
    
    func attemptToGeocode(address:String) {
        locator.geocode(address) { (placemark, error) -> Void in
            if error != nil {
                self.displayGeocodeError(error)
            } else {
                self.proceed(placemark)
            }
        }
    }
    
    func displayGeocodeError(error:NSError?) {
        print("displayGeocodeError: ")
        print(error)
    }
    
    func proceed(placemark:[CLPlacemark]?) {
        print("geocoded successfully")
        print(placemark)
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        navigationItem.hidesBackButton = true
        navigationController?.navigationBarHidden = false
        super.viewWillAppear(animated)
    }
}
