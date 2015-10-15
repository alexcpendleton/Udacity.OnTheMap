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
    func getLatest100()->[StudentLocation]
    func get(limit:Int?, skip:Int?, order:String?)->[StudentLocation]
    func create(location:StudentLocation)
}