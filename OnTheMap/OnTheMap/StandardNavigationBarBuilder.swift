//
//  StandardNavigationBarBuilder.swift
//  OnTheMap
//
//  Created by Alex Pendleton on 10/15/15.
//  Copyright © 2015 Alex Pendleton. All rights reserved.
//

import Foundation
import UIKit

public class StandardNavigationBarBuilder {
    var makePinSelector:Selector = "makePinPressed:"
    var refreshSelector:Selector = "refreshPressed:"
    
    public func build(target:UINavigationItem, viewController:UIViewController) {
        let sender = viewController
        
        /*
This begins a series of unfortunate things. 
        The Map and List ViewControllers both have essentially the same navigation bar.
        However, they each need to have their own Navigation bar tied to outlets/actions,
        which seems redundant and a bit of a code smell.         
        
        UIBarButtonItems apparently can't have
actions assigned to them which actually get called, unless you do it from IB. 

*/
        
        let x = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: sender, action: nil)
        target.rightBarButtonItems = [
            makeCustomButton(makePinSelector, image: UIImage(named: "pin"), sender: sender),
            makeCustomButton(refreshSelector, image: x.image, sender: sender)
        ]
    }
    
    private func makeCustomButton(action: Selector, image:UIImage?, sender:AnyObject?) -> UIBarButtonItem {
        
        let innerButton = UIButton()
        innerButton.setImage(image, forState: UIControlState.Normal)
        innerButton.targetForAction(makePinSelector, withSender: sender)
        innerButton.addTarget(sender, action: makePinSelector, forControlEvents: UIControlEvents.TouchUpInside)
        innerButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        var ubb = UIBarButtonItem()
        return UIBarButtonItem(customView: innerButton)
    }
    
    public func presentNewStudentLocationView(target:UINavigationController) {
//        target.pushViewController(<#T##viewController: UIViewController##UIViewController#>, animated: true)
    }
}