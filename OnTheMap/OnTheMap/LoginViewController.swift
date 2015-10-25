//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LoginViewController : UIViewController {
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    let loginService = { AppDelegate.loginService }()
    let userInfoService = { AppDelegate.userInfoService }()
    
    @IBAction func loginOnTouchUpInside() {
        attemptLogin()
    }
    
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    
    func attemptLogin() {
        if usernameField.text!.isEmpty {
            presentFailureMessage("Please enter your username.")
            return
        }
        if passwordField.text!.isEmpty {
            presentFailureMessage("Please enter your password.")
            return
        }
        
        
        let credentials = (username:usernameField.text!, password:passwordField.text!)
        loginService.attemptToLogin(credentials) { (results, error) -> Void in
            let successful = results != nil && results!.successful
            if successful {
                self.onSuccessfulLogin(results!.session!)
            } else {
                self.onFailedLogin(error!)
            }
            
        }
    }
    
    func onSuccessfulLogin(session: LoginSession) {
        userInfoService.get(session.account.key, completionHandler: { (info, error) -> Void in
            if info != nil {
                AppDelegate.currentUser = info!
                AppDelegate.currentSession = session
                self.proceed()
            } else {
                self.presentFailure(error!)
            }
        })
    }

    let proceedSegueName = "AfterLoginSegue"

    func proceed() {
        //performSegueWithIdentifier(proceedSegueName, sender: self)
        //self.performOnMainQueue {
            let toPresent = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController")
            self.presentViewController(toPresent!, animated: true, completion: nil)
        //}
        
    }
    
    func onFailedLogin(error: NSError) {
        presentFailure(error)
    }
    
    func presentFailure(error: NSError) {
        var message = "Sorry, we couldn't log you in. Please check your credentials and try again."
        
        if error.isNetworkError() {
            message = "Sorry, we seem to be having trouble connecting to the login server."
        } else {
            let httpResponse = error.userInfo["httpResponse"] as? NSHTTPURLResponse
            if httpResponse != nil {
                if [400, 403].contains(httpResponse!.statusCode) {
                    message = "Sorry, that account was not found or your credentials were invalid."
                }
            }
        }
        presentFailureMessage(message)

    }
    
    func presentFailureMessage(message:String) {
        AppDelegate.alerter.showAlert(message, title: "Login Failed", presentUsing: self)
    }
}
