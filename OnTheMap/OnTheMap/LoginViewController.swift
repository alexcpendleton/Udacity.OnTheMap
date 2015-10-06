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
            onSuccessfulLogin(results.session!)
        } else {
            onFailedLogin()
        }
    }
    
    func onSuccessfulLogin(session: LoginSession) {
        AppDelegate.currentSession = session
        proceed()
    }

    let proceedSegueName = "AfterLoginSegue"

    func proceed() {
        performSegueWithIdentifier(proceedSegueName, sender: self)
    }
    
    func onFailedLogin() {
        presentFailure()
    }
    
    func presentFailure() {
        let vc = UIAlertController(title: "Login Failed", message: "Sorry, we couldn't log you in. Please check your credentials and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            // ...
        }
        vc.addAction(OKAction)
        
        let animator = ShakeAnimator()
        
        presentViewController(vc, animated: true) { () -> Void in
            animator.animate(vc.view)
        }

    }
}

public class ShakeAnimator {
    func createAnimation() -> CAKeyframeAnimation{
        // Taken from http://stackoverflow.com/a/9371196/21201
        let anim = CAKeyframeAnimation( keyPath:"transform" )
        anim.values = [
            NSValue( CATransform3D:CATransform3DMakeTranslation(-5, 0, 0 ) ),
            NSValue( CATransform3D:CATransform3DMakeTranslation( 5, 0, 0 ) )
        ]
        anim.autoreverses = true
        anim.repeatCount = 2
        anim.duration = 10/100
        
        return anim
    }
    
    func animate(toShake: UIView) {
        toShake.layer.addAnimation(createAnimation(), forKey:nil )
    }
}
