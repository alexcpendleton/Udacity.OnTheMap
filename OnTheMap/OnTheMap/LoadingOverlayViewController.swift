//
//  LoadingOverlayViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/27/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlayViewController: UIViewController {
    @IBOutlet public weak var textLabel: UILabel?
    @IBOutlet public weak var activityIndicator: UIActivityIndicatorView?

    public var backgroundAlpha:CGFloat = 0.75
    
    public override func viewWillAppear(animated: Bool) {
        self.view.backgroundColor = self.view.backgroundColor?.colorWithAlphaComponent(backgroundAlpha)
        super.viewWillAppear(animated)
    }
}