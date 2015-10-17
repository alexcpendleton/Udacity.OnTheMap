//
//  NewLocationViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/16/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class NewLocationViewController : UIViewController {
    @IBOutlet weak var cancelButton: UIBarButtonItem?
    @IBOutlet weak var findEnteredLocationButton: UIButton?
    @IBOutlet weak var enteredLocationField: UITextField?
    
    @IBAction func findEnteredLocationPressed(sender: AnyObject?) {
        
    }
    
    @IBAction func cancelButtonPressed(sender: AnyObject?) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}