//
//  StudentLocationViewControllerBase.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/16/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class StudentLocationsViewControllerBase : UIViewController {
    public lazy var locationService: StudentLocationsServiceable = {
        return AppDelegate.studentLocationService
        }()
    public lazy var currentLocations:[StudentLocation] = {
        return self.queryLocations()
        }()
    
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    @IBOutlet weak var newPinButton: UIBarButtonItem?
    @IBOutlet weak var logoutButton: UIBarButtonItem?
    
    @IBAction func makePinPressed(sender: AnyObject) {
        print("make pin pressed")
        makeNewPin()
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        print("refresh pressed")
        refresh()
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        print("logout pressed")
    }
    
    public func makeNewPin() {
        print("make new pin called")
    }
    
    public func refresh() {
        currentLocations = queryLocations()
    }
    
    public func queryLocations() -> [StudentLocation] {
        return locationService.getLatest100()
    }
}