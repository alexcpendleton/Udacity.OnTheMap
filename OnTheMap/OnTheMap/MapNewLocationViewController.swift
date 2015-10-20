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
    
    public var chosenLocation: CLPlacemark!
    
    @IBAction func submitPressed(sender:UIButton?) {
        
    }
    
    @IBAction func cancelPressed(sender:UIButton?) {
        
    }
    
    public override func viewWillAppear(animated: Bool) {
        if useTestingDefaults {
            mediaUrlField?.text = "http://www.alexcpendleton.com"
        }
        super.viewWillAppear(animated)
    }
}