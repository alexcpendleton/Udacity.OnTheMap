//
//  LocationListViewCell.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/25/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LocationListViewCell : UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var externalLinkButton: UIButton!
    public var location: StudentLocation!
    public var delegate: PinPressedDelegate?
 
    @IBAction func externalLinkPressed(sender:AnyObject?) {
        location.mediaURL.openUrl()
    }
    
    @IBAction func pinPressed(sender:AnyObject?) {
        delegate?.onPinPressed(location, sender: sender)
    }
    
    func load(item:StudentLocation) {
        location = item
        titleLabel.text = "\(item.firstName) \(item.lastName) in \(item.mapString)"
        detailLabel.text = "\(item.mediaURL)"
    }
}