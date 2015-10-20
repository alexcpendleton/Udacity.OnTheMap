//
//  SingleButtonAlertMessager.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/19/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class SingleButtonAlertMessager {
    public func showAlert(message:String, title:String, presentUsing:UIViewController, buttonText:String = "OK") -> UIAlertController {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: buttonText, style: .Default) { (action) in
            // ...
        }
        alertController.addAction(OKAction)
        
        presentUsing.presentViewController(alertController, animated: true) {
            // ...
        }
        return alertController
    }
}