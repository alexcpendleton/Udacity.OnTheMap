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
    @IBOutlet weak var pinImage: UIImageView!
    @IBOutlet weak var externalLinkButton: UIButton!
    public var location: StudentLocation!
 
    @IBAction func externalLinkPressed(sender:AnyObject?) {
        location.mediaURL.openUrl()
    }
    
    func load(item:StudentLocation) {
        location = item
        titleLabel.text = "\(item.firstName) \(item.lastName) in \(item.mapString)"
        detailLabel.text = "\(item.mediaURL)"
        pinImage.image = UIImage(named: "pin")
        externalLinkButton.imageView?.image = UIImage(named: "external-link")
    }
}
