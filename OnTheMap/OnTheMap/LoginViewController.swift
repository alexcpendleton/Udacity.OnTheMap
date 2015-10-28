//
//  LoginViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 9/30/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LoginViewController : UIViewController, FBSDKLoginButtonDelegate {
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var signUp: AnyObject!
    @IBOutlet weak var loginWithFacebookContainer: UIView!
    @IBOutlet weak var loginWithFacebookButton: FBSDKLoginButton!
    
    var useTestingDefaults = { AppDelegate.useTestingDefaults }()
    var sessionManager = { AppDelegate.sessionManager }()
    
    public override func viewWillAppear(animated: Bool) {
        if useTestingDefaults {
            usernameField.text = "fakertonmcnotreal@mailinator.com"
            passwordField.text = "nope"
        }
        
        // Hide the "Login" text on the button as we will show 
        // an activity indicator instead
        loginButton.setTitle("", forState: UIControlState.Disabled)

        // Use Facebook's own button
        loginWithFacebookButton.delegate = self
        super.viewWillAppear(animated)
    }
    
    public func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        
        if ((error) != nil)
        {
            onFailedLogin(error)
        }
        else if result.isCancelled {
            presentFailureMessage("Facebook login cancelled.")
        }
        else {
            let t = result.token.tokenString
            attemptLogin(withCredentials: FacebookCredential(token: t))
        }
    }
    
    public func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        // We hide this button when logged in, so there's no need to 
        // implement anything to handle the button press
    }
    
    @IBAction func loginOnTouchUpInside() {
        attemptLogin()
    }
    
    @IBAction func signUpTouchUpInside() {
        openSignUpLink()
    }
    
    func openSignUpLink() {
        "https://www.udacity.com/account/auth#!/signup".openUrl()
    }
    
    func attemptLogin() {
        if usernameField.text!.isEmpty {
            presentFailureMessage("Please enter your username.")
            return
        }
        if passwordField.text!.isEmpty {
            presentFailureMessage("Please enter your password.")
            return
        }
        let credentials = UsernamePasswordCredential(username: usernameField.text!, password: passwordField.text!)
        attemptLogin(withCredentials: credentials)
    }
    
    func attemptLogin(withCredentials credentials:LoginCreditable) {
        applyLoginCallStartingStyles()
        sessionManager.login(credentials) { (sm, error) -> Void in
            let results = sm?.currentSession
            let successful = results != nil && error == nil
            if successful {
                self.applyLoginCallFinishedStyles(true) {
                    self.proceed()
                }
            } else {
                // Facebook can get us a token but that doesn't mean 
                // we've actually linked our Udacity account to Facebook
                // (Or we had at one time and disconnected it)
                // If that's the case we want to force a Facebook logout
                self.sessionManager.logout {_,_ in
                    self.applyLoginCallFinishedStyles(false) {
                        self.onFailedLogin(error!)
                    }
                }
            }
        }
        
    }
    var overlay:LoadingOverlayViewController?
    func applyLoginCallStartingStyles() {
        //loginButton.enabled = false
        //loginActivityIndicator.startAnimating()
        self.definesPresentationContext = true
        overlay = (storyboard?.instantiateViewControllerWithIdentifier("LoadingOverlayViewController") as! LoadingOverlayViewController)
        overlay!.modalPresentationStyle = UIModalPresentationStyle.OverCurrentContext

        loginWithFacebookButton.hidden = true
        presentViewController(overlay!, animated: false, completion: nil)
    }
    
    func applyLoginCallFinishedStyles(succeeded:Bool, completion:()->()) {
        overlay!.dismissViewControllerAnimated(false) {
            // The facebook button looks weird when logged in
            // and we don't really want to show it anyway
            self.loginWithFacebookButton.hidden = succeeded
            completion()
        }
    }
    
    func proceed() {
        let toPresent = self.storyboard?.instantiateViewControllerWithIdentifier("MainTabBarController")
        self.presentViewController(toPresent!, animated: true, completion: nil)
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
