//
//  DetailsTableViewController.swift
//  Map
//
//  Created by Howard Jiang on 5/17/16.
//  Copyright © 2016 pegah. All rights reserved.
//

import UIKit

class DetailsTableViewController: UITableViewController, CancelButtonDelegate{
    
    
    struct Objects {
        var sectionName : String!
        var sectionObjects : [String]!
    }
    
    var objectsArray = [Objects]()
    
   
    var showTrips: Bool? = false
    var showPins: Bool? = false
    var goToMap: Bool? = false
    
    var tripInfoToSend: String?
    var pinInfoToSend: String?
    
    var tripInfoArr = [String]()
    var pinInfoArr = [String]()
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
   
    
    
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Got to detailstabview")
        
        self.tableView.separatorColor = UIColor.blueColor()
        let blurredBackgroundView = BlurredBackgroundView(frame: .zero)
        self.tableView.backgroundView = blurredBackgroundView
        self.tableView.separatorEffect = UIVibrancyEffect(forBlurEffect: blurredBackgroundView.blurView.effect as! UIBlurEffect)
        
        if(showTrips == true){
            tripByUserName()
            print("Got to Trips")
        }
        else if (showPins == true){
            pinsByUserName()
            print("Got to pins")
        }
    }
    
    @IBAction func showFriendTapped(sender: AnyObject) {
        showFriends()
    }
    
    
    
    func showFriends() {
        let parameters = ["fields": "name,picture.type(normal),gender"]
        FBSDKGraphRequest(graphPath: "/me/taggable_friends", parameters: parameters).startWithCompletionHandler({ (connection, user, requestError) -> Void in
            if requestError != nil {
                print(requestError)
                return
            }
            
            var friends = [Friend]()
            for friendDictionary in user["data"] as! [NSDictionary] {
                let name = friendDictionary["name"] as? String
                if let picture = friendDictionary["picture"]?["data"]?!["url"] as? String {
                    let friend = Friend(name: name, picture: picture)
                    friends.append(friend)
                }
            }

            let friendsController = FriendController(collectionViewLayout: UICollectionViewFlowLayout())
            friendsController.friends = friends
            self.navigationController?.pushViewController(friendsController, animated: true)
            self.navigationController?.navigationBar.tintColor = UIColor.blackColor()
        })
    }


    
    func tripByUserName() {
        
        let FBUserID = defaults.stringForKey("UserId")
        let baseUrl = "http://54.153.97.181/json/trips/" + FBUserID!
        
        print("inside the trip function")
        
        let url = NSURL(string: baseUrl)
        let session = NSURLSession.sharedSession()
        print("right before datataskwithurl")
        let task = session.dataTaskWithURL(url!, completionHandler: {
            
            data, response, error in
            do {
                print("Got to trip response thing")
                print("data: \n \(data)")
                
                if let trips = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    self.objectsArray = [Objects]()
                    
                    self.objectsArray.append(Objects(sectionName: "My Saved Trips", sectionObjects: []))
                    
                    for i in 0...trips["trips"]!.count-1{
                        let name = trips["trips"]![i]!["name"] as! String
                        print(name)
                        self.objectsArray[0].sectionObjects.append(name)
                        
                        
                        let id = trips["trips"]![i]!["tripId"] as! String
                        let coords = trips["trips"]![i]!["trip"] as! String
                        let distance = trips["trips"]![i]!["distance"] as! String
                        let duration = trips["trips"]![i]!["duration"] as! String
                        
                        var addStr = ""
                        addStr = "TripID;\(id)!TripName;\(name)!TripCoords;\(coords)!TripDistance;\(distance)!TripDuration;\(duration)"
                        
                        print(addStr)
                        self.tripInfoArr.append(addStr)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    print("Something went right")
                    self.friendTrips()
   
                }
            }
                catch {
                print("Something went wrong")
            }
        })
        
        task.resume()
    }
    
    
    func friendTrips(){
        let FBUserID = defaults.stringForKey("UserId")
        let baseUrl = "http://54.153.97.181/json/notTrips/" + FBUserID!
        
        print("inside the nottrip function")
        
        let url = NSURL(string: baseUrl)
        let session = NSURLSession.sharedSession()
        print("right before datataskwithurl")
        let task = session.dataTaskWithURL(url!, completionHandler: {
            
            data, response, error in
            do {
                print("Got to nottrip response thing")
                print("data: \n \(data)")
                
                if let trips = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    self.objectsArray.append(Objects(sectionName: "My Shared Trips", sectionObjects: []))
                    
                    for i in 0...trips["trips"]!.count-1{
                        let name = trips["trips"]![i]!["name"] as! String
                        print(name)
                        self.objectsArray[1].sectionObjects.append(name)
                        
                        
                        let id = trips["trips"]![i]!["tripId"] as! String
                        let coords = trips["trips"]![i]!["trip"] as! String
                        let distance = trips["trips"]![i]!["distance"] as! String
                        let duration = trips["trips"]![i]!["duration"] as! String
                        
                        var addStr = ""
                        addStr = "TripID;\(id)!TripName;\(name)!TripCoords;\(coords)!TripDistance;\(distance)!TripDuration;\(duration)"
                        
                        print(addStr)
                        self.tripInfoArr.append(addStr)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    print("Something went right")
                    
                }
            }
            catch {
                print("Something went wrong")
            }
        })
        
        task.resume()
    }
    
    
    
    
    
    func pinsByUserName(){
        
        let FBUserID = defaults.stringForKey("UserId")
        let baseUrl = "http://54.153.97.181/json/pins/" + FBUserID!
        
        print("inside the pin function")
        
        let url = NSURL(string: baseUrl)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            
            data, response, error in
            do {
                
                if let pins = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
                    self.objectsArray = [Objects]()
                    
                    self.objectsArray.append(Objects(sectionName: "My Saved Pins", sectionObjects: []))
                    
                    for i in 0...pins["pins"]!.count-1{
                        
                        let id = pins["pins"]![i]!["pinId"] as! String
                        let coord = pins["pins"]![i]!["coordinate"] as! String
                        let note = pins["pins"]![i]!["note"] as! String
                        
                        self.objectsArray[0].sectionObjects.append(note)
                        
                        var addStr = ""
                        addStr = "PinID;\(id)!PinNote;\(note)!PinCoords;\(coord)"
                        
                        //                        print(addStr)
                        self.pinInfoArr.append(addStr)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })

                    print("Something went right")
                    self.friendPins()
                 }
            }
            catch {
                print("Something went wrong")
            }
        })
        
        task.resume()
        
    }
    
    
    
    func friendPins(){
        
        let FBUserID = defaults.stringForKey("UserId")
        let baseUrl = "http://54.153.97.181/json/notPins/" + FBUserID!
        
        print("inside the notpin function")
        
        let url = NSURL(string: baseUrl)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(url!, completionHandler: {
            
            data, response, error in
            do {
                
                if let pins = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary {
                    
//                    self.objectsArray = [Objects]()
                    
                    self.objectsArray.append(Objects(sectionName: "My Shared Pins", sectionObjects: []))
                    
                    for i in 0...pins["pins"]!.count-1{
                        
                        let id = pins["pins"]![i]!["pinId"] as! String
                        let coord = pins["pins"]![i]!["coordinate"] as! String
                        let note = pins["pins"]![i]!["note"] as! String
                        
                        self.objectsArray[1].sectionObjects.append(note)
                        
                        var addStr = ""
                        addStr = "PinID;\(id)!PinNote;\(note)!PinCoords;\(coord)"
                        
                        //                        print(addStr)
                        self.pinInfoArr.append(addStr)
                        
                    }
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                    })
                    
                    print("Something went right")
                }
            }
            catch {
                print("Something went wrong")
            }
        })
        
        task.resume()
        
    }
    
    
    
    
    
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TripCell")! as UITableViewCell!
         cell.backgroundColor = UIColor.clearColor()
        cell.textLabel?.textColor = UIColor.whiteColor()
        cell.textLabel?.font = UIFont(name: "HelveticaNeue-Thin", size: 18)
        cell.textLabel?.text = objectsArray[indexPath.section].sectionObjects[indexPath.row]
        
        return cell
    }
    
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return objectsArray[section].sectionObjects.count
    }
    
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return objectsArray.count
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return objectsArray[section].sectionName
        
    }
    
    
    @IBAction func CancelButton(sender: UIBarButtonItem) {
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        goToMap = true
        
        if(showTrips == true){
            tripInfoToSend = tripInfoArr[indexPath.row]
        }
        if(showPins == true){
            pinInfoToSend = pinInfoArr[indexPath.row]
        }
        
        performSegueWithIdentifier("MapDetails", sender: tableView.cellForRowAtIndexPath(indexPath))
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(showTrips == true){
            if( goToMap == true){
            
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! ViewController
                controller.cancelButtonDelegate = self
                controller.fromMaps = true
                controller.fromMapsPins = false
                goToMap = false

                controller.tripInfo = String(tripInfoToSend!)
            }
        }
        else if(showPins == true){
            if( goToMap == true){
                
                let navigationController = segue.destinationViewController as! UINavigationController
                let controller = navigationController.topViewController as! ViewController
                controller.cancelButtonDelegate = self
                controller.fromMaps = false
                controller.fromMapsPins = true
                goToMap = false
                
                controller.pinInfo = String(pinInfoToSend!)
                
            }
        }
     
    }
    
    
    func cancelButtonPressedFrom(controller: UIViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}

class BlurredBackgroundView: UIView {
    let imageView: UIImageView
    let blurView: UIVisualEffectView
    
    override init(frame: CGRect) {
        let blurEffect = UIBlurEffect(style: .Dark)
        blurView = UIVisualEffectView(effect: blurEffect)
        imageView = UIImageView(image: UIImage.gorgeousImage())
        super.init(frame: frame)
        addSubview(imageView)
        addSubview(blurView)
    }
    
    convenience required init?(coder aDecoder: NSCoder) {
        self.init(frame: CGRectZero)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
        blurView.frame = bounds
    }
}

extension UIImage {
    class func gorgeousImage() -> UIImage {
        return UIImage(named: "tripPage")!
    }
}

