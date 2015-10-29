//
//  KeyboardManager.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/28/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit
public protocol KeyboardManagerDelegate {
    func keyboardWillShow(keyboardHeight:CGFloat)
    func keyboardWillHide(keyboardHeight:CGFloat)
}
public class KeyboardManager : NSObject {
    init(inViewController: UIViewController, delegate d: KeyboardManagerDelegate) {
        target = inViewController
        delegate = d
    }
    var target: UIViewController
    var delegate: KeyboardManagerDelegate
    var tapRecognizer: UITapGestureRecognizer!
    var view: UIView { get { return target.view } }
    
    public func register() {
        tapRecognizer = UITapGestureRecognizer(target: self, action: "handleSingleTap:")
        tapRecognizer.numberOfTapsRequired = 1
        view.addGestureRecognizer(tapRecognizer)
        subscribeToKeyboardNotifications()
    }
    
    public func unregister() {
        view.removeGestureRecognizer(tapRecognizer)
        unsubscribeToKeyboardNotifications()
    }
    
    func subscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func handleSingleTap(recognizer: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.CGRectValue().height
    }
    
    public func keyboardWillShow(notification: NSNotification) {
        delegate.keyboardWillShow(self.getKeyboardHeight(notification))
    }
    
    public func keyboardWillHide(notification: NSNotification) {
        delegate.keyboardWillHide(self.getKeyboardHeight(notification))
        
    }
}