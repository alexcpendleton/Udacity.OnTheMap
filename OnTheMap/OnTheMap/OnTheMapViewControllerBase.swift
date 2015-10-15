//
//  OnTheMapViewControllerBase.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/14/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class OnTheMapViewControllerBase: UIViewController {
    public func setDefaultTitle() {
        navigationController?.title = "On the Map"
        navigationItem.title = "On the Map"
    }
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
}