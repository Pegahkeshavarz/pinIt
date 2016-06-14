//
//  UserMenuViewController.swift
//  Map
//
//  Created by Howard Jiang on 5/17/16.
//  Copyright © 2016 pegah. All rights reserved.
//

import UIKit
import Foundation


protocol CancelButtonDelegate: class {
    func cancelButtonPressedFrom(controller: UIViewController)
}

protocol MapInfoDelegate: class {
    func MapInfoButtonPressed(controller: UIViewController)
}


class UserMenuViewController: UIViewController, CancelButtonDelegate {
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
   
    @IBOutlet weak var backButtonLabel: UIButton!
    @IBOutlet weak var shareTripLabel: UIButton!
    @IBOutlet weak var userNameLabel: UILabel!
    var tripOrPin: String?
    
    @IBOutlet weak var myOldTripsLabel: UIButton!
    
    
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
                
        let imageView = UIImageView(frame: self.view.bounds)
        imageView.image = UIImage(named: "tripPage.png")
        self.view.addSubview(imageView)
        view.sendSubviewToBack(imageView)
        
        //adding border line to buttons
        let borderAlpha : CGFloat = 0.7
        let cornerRadius : CGFloat = 5.0
        myOldTripsLabel.frame = CGRectMake(100, 100, 200, 40)
        myOldTripsLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        myOldTripsLabel.backgroundColor = UIColor.clearColor()
        myOldTripsLabel.layer.borderWidth = 1.0
        myOldTripsLabel.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        myOldTripsLabel.layer.cornerRadius = cornerRadius
        
        shareTripLabel.frame = CGRectMake(100, 100, 200, 40)
        shareTripLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        shareTripLabel.backgroundColor = UIColor.clearColor()
        shareTripLabel.layer.borderWidth = 1.0
        shareTripLabel.layer.borderColor = UIColor(white: 1.0, alpha: borderAlpha).CGColor
        shareTripLabel.layer.cornerRadius = cornerRadius
        
    
        
        
        backButtonLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        userNameLabel.textColor = UIColor.whiteColor()
        userNameLabel.text = defaults.stringForKey("userName")
    }
    
    
    @IBAction func TripButton(sender: UIButton) {
        tripOrPin = "trip"
        performSegueWithIdentifier("Details", sender: self)
    }
    
    @IBAction func PinButton(sender: UIButton) {
        tripOrPin = "pin"
        performSegueWithIdentifier("Details", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(tripOrPin == "trip"){
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! DetailsTableViewController
            controller.showTrips = true
            controller.showPins = false
            controller.cancelButtonDelegate = self
            tripOrPin = ""
        }
        else if(tripOrPin == "pin"){
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! DetailsTableViewController
            controller.showPins = true
            controller.showTrips = false
            controller.cancelButtonDelegate = self
            tripOrPin = ""
        }
        
    }
    
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}
