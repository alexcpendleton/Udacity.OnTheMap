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
        if self.isMovingToParentViewController() {
            refresh()
        }
        tabBarController?.tabBar.hidden = false
        super.viewWillAppear(animated)
    }
    
    @IBAction func makePinPressed(sender: AnyObject) {
        makeNewPin()
    }
    
    @IBAction func refreshPressed(sender: AnyObject) {
        refresh()
    }
    
    @IBAction func logoutPressed(sender: AnyObject) {
        print("logout pressed")
    }
    
    public func makeNewPin() {
        instantiateAndPresentNewLocationView()
    }
    
    public func refresh() {
        currentLocations = queryLocations()
    }
    
    public func queryLocations() -> [StudentLocation] {
        return locationService.getLatest100()
    }
    
    public func instantiateAndPresentNewLocationView() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("NewLocationViewController") as! NewLocationViewController? {
            
            tabBarController?.tabBar.hidden = true
            navigationController?.pushViewController(target, animated: true)
        }
    }
}