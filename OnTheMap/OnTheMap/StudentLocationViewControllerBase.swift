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
    
    override public func viewWillAppear(animated: Bool) {
        tabBarController?.tabBar.hidden = false
        super.viewWillAppear(animated)
    }
    
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
        instantiateAndPresentNewLocationView()
    }
    
    public func refresh() {
        currentLocations = queryLocations()
    }
    
    public func queryLocations() -> [StudentLocation] {
        return locationService.getLatest100()
    }
    
    public func instantiateAndPresentNewLocationView() {
        let modally = true
        if modally {
            if let target = storyboard?.instantiateViewControllerWithIdentifier("NewLocationViewController") as! NewLocationViewController? {
                
                tabBarController?.tabBar.hidden = true
                navigationController?.pushViewController(target, animated: true)
                
                
            } else {
                if let target = storyboard?.instantiateViewControllerWithIdentifier("NewLocationNavigationController") {
                    presentViewController(target, animated: true, completion: nil)
                }
            }
        }
    }
}