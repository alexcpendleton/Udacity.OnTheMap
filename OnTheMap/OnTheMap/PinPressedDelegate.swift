//
//  PinPressedDelegate.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/26/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation

public protocol PinPressedDelegate {
    func onPinPressed(location:StudentLocation, sender:AnyObject?)
}