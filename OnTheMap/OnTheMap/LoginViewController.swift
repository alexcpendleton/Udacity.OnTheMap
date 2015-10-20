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
        let credentials = (username:usernameField.text!, password:passwordField.text!)
        let results = loginService.attemptToLogin(credentials)
        if results.successful {
            onSuccessfulLogin(results.session!)
        } else {
            onFailedLogin()
        }
    }
    
    func onSuccessfulLogin(session: LoginSession) {
        userInfoService.get(session.account.key, completionHandler: { (info, error) -> Void in
            if info != nil {
                AppDelegate.currentUser = info!
                AppDelegate.currentSession = session
                self.proceed()
            } else {
                self.presentFailure()
            }
        })
    }

    let proceedSegueName = "AfterLoginSegue"

    func proceed() {
        performSegueWithIdentifier(proceedSegueName, sender: self)
    }
    
    func onFailedLogin() {
        presentFailure()
    }
    
    func presentFailure() {
        AppDelegate.alerter.showAlert("Sorry, we couldn't log you in. Please check your credentials and try again.", title: "Login Failed", presentUsing: self)

    }
}
