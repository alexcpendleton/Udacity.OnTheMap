//
//  LocationListViewController.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/14/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class LocationListViewController : StudentLocationsViewControllerBase, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    var refreshControl = UIRefreshControl()
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.delegate = self
        tableView.dataSource = self
        //http://stackoverflow.com/a/15010646/21201
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    
    public override func currentLocationsUpdated() {
        tableView.reloadData()
    }
    
    public func refresh(refreshControl: UIRefreshControl) {
        // When we're doing the pull-down refresh we want to hide
        // the default activity indicator on the ViewController and
        // just display the refreshControl's.
        let tempHolder = activityIndicator
        activityIndicator = nil
        refresh()
        refreshControl.endRefreshing()
        activityIndicator = tempHolder
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
    
    public func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let item = currentLocations[indexPath.row]
        item.mediaURL.openUrl()
    }
}