//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/14/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LocationListViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    public lazy var locationService: StudentLocationsServiceable = {
        return AppDelegate.studentLocationService
        }()
    private lazy var currentLocations:[StudentLocation] = {
        return self.queryLocations()
    }()
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func queryLocations() -> [StudentLocation] {
        return locationService.getLatest100()
    }
    
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1 
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentLocations.count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("LocationCell") as UITableViewCell!
        let item = currentLocations[indexPath.row]
        cell.textLabel?.text = item.description
        cell.imageView?.image = UIImage(named: "pin")
        return cell
    }
}