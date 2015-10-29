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
    public lazy var sessionManager: SessionManager = {
        return AppDelegate.sessionManager
    }()
    @IBOutlet weak var refreshButton: UIBarButtonItem?
    @IBOutlet weak var newPinButton: UIBarButtonItem?
    @IBOutlet weak var logoutButton: UIBarButtonItem?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView?
    
    override public func viewWillAppear(animated: Bool) {
        activityIndicator?.color = self.view.tintColor
        tabBarController?.tabBar.hidden = false
        updateCurrentLocationsIfPossible()
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
        sessionManager.logout {_,_ in 
            // Don't really care if there were errors or not
            self.presentLogin()
        }
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
        // Clear the cache since we're asking explicitly for
        // fresh data
        AppDelegate.studentLocationService.clearCacheIfApplicable()
        updateCurrentLocationsIfPossible()
    }
    
    public func currentLocationsUpdated() {
        
    }
    
    public func locationsGetFailed(error:NSError) {
        AppDelegate.alerter.showAlert("Sorry, we were unable to fetch the latest locations!", title: "Locations Error", presentUsing: self)
    }
    
    public func updateCurrentLocationsIfPossible() {
        queryLocations { (locations, error) -> Void in
            if error == nil {
                // Signal to inheritors that the locations have changed
                // Maybe this should be done via 'hasChanged'?
                self.currentLocationsUpdated()
            } else {
                self.locationsGetFailed(error!)
            }
        }
    }
    
    public func applyQueryingStyles() {
        activityIndicator?.startAnimating()
    }
    
    public func applyQueryFinishedStyles() {
        activityIndicator?.stopAnimating()
    }
    
    public func queryLocations(completionHandler: ([StudentLocation]?, NSError?)->Void) {
        applyQueryingStyles()
        AppDelegate.studentLocationService.getLatest100 {
            self.applyQueryFinishedStyles()
            completionHandler($0, $1)
        }
    }
    
    public func instantiateAndPresentNewLocationView() {
        if let target = storyboard?.instantiateViewControllerWithIdentifier("NewLocationViewController") as! NewLocationViewController? {
            
            tabBarController?.tabBar.hidden = true
            navigationController?.pushViewController(target, animated: true)
        }
    }
}