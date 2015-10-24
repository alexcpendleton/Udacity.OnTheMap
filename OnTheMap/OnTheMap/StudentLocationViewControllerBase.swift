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
    public lazy var currentLocations = [StudentLocation]()
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    @IBOutlet weak var newPinButton: UIBarButtonItem?
    @IBOutlet weak var logoutButton: UIBarButtonItem?
    
    override public func viewWillAppear(animated: Bool) {
        refresh()
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
        logout()
    }
    
    public func logout() {
        // Smells, too much non-view logic in here
        AppDelegate.currentUser = nil
        AppDelegate.currentSession = nil
        presentLogin()
    }
    
    public func presentLogin() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController? {
             presentViewController(target, animated: true, completion: nil)
        }
    }
    
    public func makeNewPin() {
        instantiateAndPresentNewLocationView()
    }
    
    public func refresh() {
        updateCurrentLocationsIfPossible()
    }
    public func currentLocationsUpdated() {
        
    }
    public func updateCurrentLocationsIfPossible() {
        queryLocations { (locations, error) -> Void in
            if locations != nil {
                self.currentLocations = locations!
            }
            // Silently fail on errors for now, per the direction of
            // the iOS networking instructor.
            // The next course supposedly will give guidance on
            // more friendly networking error issues
            
            // Signal to inheritors that the locations have changed
            // Maybe this should be done via 'hasChanged'?
            self.currentLocationsUpdated()
        }
    }
    
    public func queryLocations(completionHandler: ([StudentLocation]?, NSError?)->Void) {
        locationService.getLatest100(completionHandler)
    }
    
    public func instantiateAndPresentNewLocationView() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("NewLocationViewController") as! NewLocationViewController? {
            
            tabBarController?.tabBar.hidden = true
            navigationController?.pushViewController(target, animated: true)
        }
    }
}