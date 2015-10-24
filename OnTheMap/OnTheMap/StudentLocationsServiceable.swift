//
//  LocationsServiceable.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/5/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public protocol StudentLocationsServiceable {
    func getLatest100(completionHandler:([StudentLocation]?, NSError?)->Void)
    func get(limit:Int?, skip:Int?, order:String?, completionHandler:([StudentLocation]?, NSError?)->Void)
    func create(location: StudentLocation, completionHandler:(StudentLocation?, NSError?)->Void)
}