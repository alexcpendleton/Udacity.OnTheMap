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
    
    @IBAction func loginOnTouchUpInside() {
        attemptLogin()
    }
    
    @IBOutlet weak var usernameField:UITextField!
    @IBOutlet weak var passwordField:UITextField!
    
    func attemptLogin() {
        let credentials = (username:usernameField.text!, password:passwordField.text!)
        let results = loginService.attemptToLogin(credentials)
        if results.successful {
            onSuccessfulLogin()
        } else {
            onFailedLogin()
        }
    }
    
    func onSuccessfulLogin() {
        
    }
    
    func onFailedLogin() {
        
    }
}