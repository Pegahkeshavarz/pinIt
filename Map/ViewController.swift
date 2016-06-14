//
//  ViewController.swift
//  MapKitCoreLocation
//
//  Created by Sharol Chand on 5/12/16.
//  Copyright © 2016 Sharol Chand. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    @IBOutlet weak var tripNameInputField: UITextField!
    
    
    @IBOutlet weak var deleteTrip: UIBarButtonItem!
   
    @IBOutlet weak var doneButtonLabel: UIButton!
    @IBOutlet weak var nameYourTripLabel: UILabel!
    let defaults = NSUserDefaults.standardUserDefaults()
    
    
    weak var cancelButtonDelegate: CancelButtonDelegate?
    
    
    @IBAction func userDetails(sender: UIButton) {
        performSegueWithIdentifier("userDetails", sender: self)
    }
    
    // Variables for specific trip getting
    var fromMaps: Bool? = false
    var tripCoords = [CLLocationCoordinate2D(latitude: 37.377375560608534, longitude: -121.91225781001422),
                      CLLocationCoordinate2D(latitude: 37.377339962324889, longitude: -121.91228729665251),
                      CLLocationCoordinate2D(latitude: 37.377369638020127, longitude: -121.91232907647191),
                      CLLocationCoordinate2D(latitude: 37.377328798296034, longitude: -121.91226145129352),
                      CLLocationCoordinate2D(latitude: 37.377322179601009, longitude: -121.91235503395197),
                      CLLocationCoordinate2D(latitude: 37.377365438964368, longitude: -121.91231220902186),
                      CLLocationCoordinate2D(latitude: 37.377372978198629, longitude: -121.91229857327063)]
    
    var tripDuration: String = "5m 35s"
    var tripShowDistance: String = "0mi 50ft"
    var tripName: String = ""
    var tripID = ""
    var tripInfo: String?
    
    @IBOutlet weak var BackButtonLabel: UIBarButtonItem!
    @IBOutlet weak var DeleteButtonLabel: UIBarButtonItem!
    
    
    var pinID = ""
    var pinCoord = [CLLocationCoordinate2D(latitude: 37.377375560608534, longitude: -121.91225781001422)]
    var pinNote = ""
    var fromMapsPins = false
    var pinInfo: String?
    
    
    
    
    func drawTripOnMap(){
        
        // Draw Line
        let line = MKPolyline(coordinates: &tripCoords, count: tripCoords.count)
        self.mapView.addOverlay((line), level: MKOverlayLevel.AboveRoads)
        
        
        // Place start pin
        let Placemark = MKPlacemark(coordinate: tripCoords[0], addressDictionary: nil)
        _ = MKMapItem(placemark: Placemark)
        
        let Annotation = MKPointAnnotation()
        Annotation.title = tripName
        
        if let location = Placemark.location {
            Annotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([Annotation], animated: true )
        
        // Place end pin
        let count = tripCoords.count - 1
        let Placemark2 = MKPlacemark(coordinate: tripCoords[count], addressDictionary: nil)
        _ = MKMapItem(placemark: Placemark2)
        
        let Annotation2 = MKPointAnnotation()
        Annotation2.title = "Trip distance: \(tripShowDistance)"
        Annotation2.subtitle = "Trip Duration: \(tripDuration)"
        
        if let location = Placemark2.location {
            Annotation2.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([Annotation2], animated: true )

        // Zoom in on trip
        let locationCoord = CLLocationCoordinate2D(latitude: tripCoords[0].latitude,
                                                   longitude: tripCoords[0].longitude)
        let region = MKCoordinateRegion(center: locationCoord, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    func drawPinOnMap(){
        
        // Place pin
        let Placemark = MKPlacemark(coordinate: pinCoord[0], addressDictionary: nil)
        _ = MKMapItem(placemark: Placemark)
        
        let Annotation = MKPointAnnotation()
        Annotation.title = pinNote
        
        if let location = Placemark.location {
            Annotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([Annotation], animated: true )
        
        
        // Zoom in on pin
        let locationCoord = CLLocationCoordinate2D(latitude: pinCoord[0].latitude,
                                                   longitude: pinCoord[0].longitude)
        let region = MKCoordinateRegion(center: locationCoord, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
        
        self.mapView.setRegion(region, animated: true)
        
    }
    
    
    func postTrip(name: String, trip: String, distance: String, duration: String, userId: String){
        let urlToReq = NSURL(string: "http://54.153.97.181/addTrips/")
        let request = NSMutableURLRequest(URL: urlToReq!)
        request.HTTPMethod = "POST"
        
        let bodyData = "name=\(name)&trip=\(trip)&distance=\(distance)&duration=\(duration)&userId=\(userId)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            do{}
            
            
        }
        task.resume()
    }
    
    
    func postPin(coordinate: String, username: String, note: String){
        let urlToReq = NSURL(string: "http://54.153.97.181/addPins/")
        let request = NSMutableURLRequest(URL: urlToReq!)
        request.HTTPMethod = "POST"
        
        let bodyData = "coordinate=\(coordinate)&username=\(username)&note=\(note)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            do{}
            
            
        }
        task.resume()
    }
    
    
    
    @IBAction func BackToMapButton(sender: UIBarButtonItem) {
        fromMaps = false
        fromMapsPins = false
        cancelButtonDelegate?.cancelButtonPressedFrom(self)
    }
    
    
    @IBAction func DeleteTripButton(sender: AnyObject) {
        print("Delete 35")
        /* RETRIEVE/SET trip_id here */
        deleteTrip(Int(tripID)!)
        BackToMapButton(deleteTrip)
    }
    
    
    func deleteTrip(trip_id: Int){
        
        let urlToReq = NSURL(string: "http://54.153.97.181/deleteTrip/")
        let request = NSMutableURLRequest(URL: urlToReq!)
        request.HTTPMethod = "POST"
        
        let bodyData = "trip_id=\(trip_id)"
        request.HTTPBody = bodyData.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            
            data, response, error in
            
            do{}
            
        }
        task.resume()
        
    }
    
    
    
    
    var locationManager = CLLocationManager()
    var coordinatepoints = [[CLLocationCoordinate2D]()]
    var coordInd = 0
    var distance: Double = 0.00 // Distance
    var tempDistance = 0.00
    var tripDistance = 0.00
    var shouldDraw = false
    var lineColor = 0
    var reuseID = ""
    
    
    @IBOutlet weak var imageLabel: UIImageView!
    
    
    
    @IBOutlet weak var userNameLabel: UIButton!
    @IBOutlet weak var totalDistCount: UILabel!
    
    @IBOutlet weak var totalDistanceLabel: UILabel!
  
    @IBOutlet weak var addbuttonLabel: UIButton!
    @IBOutlet weak var displayTime: UILabel!
    
    @IBOutlet weak var stopButtonLabel: UIButton!
    
    @IBOutlet weak var startButtonLabel: UIButton!
 
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var totalTimeCountLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var leaveNoteField: UITextField!
    
    //Timer shit
    var startTime = NSTimeInterval()
    var timer = NSTimer()
    var lastTime: String?
    var totalTime: Int = 0
    var showNote: String?
    
    var showTime: Int = 0
    var userID = false
    
    
    
    func formatStrToCLLocationCoordinate2D(str : String) -> [CLLocationCoordinate2D] {
        //Separate all of the coordinates by '?'
        var arrayOne : [String] = str.componentsSeparatedByString("?")
        //Create a new array to modify.
        var returnArray : [CLLocationCoordinate2D] = []
        
        //Loop through the array, Grab
        for i in 0...arrayOne.count-1 {
            //Variables for start.
            var things : [String] = arrayOne[i].componentsSeparatedByString(",")
            
            //Double of the first thing 'latitude' make to Degrees
            var CoordDbl : Double = Double(things[0])!
            let lat = CLLocationDegrees(CoordDbl)
            //Double of the second thing 'Longitude' make to Degrees
            CoordDbl = Double(things[1])!
            let long = CLLocationDegrees(CoordDbl)
            //Create Coordinates with the Degrees
            let coord = CLLocationCoordinate2DMake(lat, long)
            
            //Modify the array.
            returnArray.append(coord)
        }
        //Return the Array that we modified
        return returnArray
    }



    override func viewDidLoad() {
        
        print("------------------------FACEBOOK ID-------------------------\n")
        print(defaults.stringForKey("UserId"))
        
        if(fromMaps == true){
            print("\n\n\n\n\n----------------------Map viewdidLoad from Map List----------------------\n\n\n\n\n")
            
            BackButtonLabel.title = "Back to My Trips"
            DeleteButtonLabel.title = "Delete Trip"
            
            
            //            print("trip info from details controller: \n\n\(tripInfo!) \n\n\n\n\n\n\n\n\n")
            
            let TempInfoArr = tripInfo!.componentsSeparatedByString("!")
            print("\n\n\n\(TempInfoArr)\n\n\n")
            
            let tripIDstr = TempInfoArr[0].componentsSeparatedByString(";")
            tripID = tripIDstr[1]
            //            print("Just got trip id")
            let tripNamestr = TempInfoArr[1].componentsSeparatedByString(";")
            tripName = tripNamestr[1]
            //            print("Just got trip name")
            let tripCoordstr = TempInfoArr[2].componentsSeparatedByString(";")
            print("tripCoordstr:   \(tripCoordstr)\n\n\n\n\n")
            let passCoords = tripCoordstr[1]
            tripCoords = formatStrToCLLocationCoordinate2D(passCoords)
            //            print("Just got trip coords")
            let tripDiststr = TempInfoArr[3].componentsSeparatedByString(";")
            tripShowDistance = tripDiststr[1]
            //            print("Just got trip dist")
            let tripDurstr = TempInfoArr[4].componentsSeparatedByString(";")
            tripDuration = printSecondsToHoursMinutesSeconds(Int(tripDurstr[1])!)
            //            print("Just got trip dur")
            
            //            print("Trip ID: \(tripID)\n\nTrip Name: \(tripName)\n\nTrip Coords: \(tripCoords)\n\nTrip Distance: \(tripDistance)\n\nTrip Duration: \(tripDuration)\n\n\n")
            
            drawTripOnMap()
            fromMaps = false
            imageLabel.hidden = true
        }
        if(fromMapsPins == true){
            
            print("\n\n\n\n\n----------------------Map viewdidLoad from Pin List----------------------\n\n\n\n\n")
            
            BackButtonLabel.title = "Back to My Pins"
            DeleteButtonLabel.title = "Delete Pin"
            
            let TempInfoArr = pinInfo!.componentsSeparatedByString("!")
            
            let pinIDstr = TempInfoArr[0].componentsSeparatedByString(";")
            pinID = pinIDstr[1]
            let pinNotestr = TempInfoArr[1].componentsSeparatedByString(";")
            pinNote = pinNotestr[1]
            let pinCoordstr = TempInfoArr[2].componentsSeparatedByString(";")
            pinCoord = formatStrToCLLocationCoordinate2D(pinCoordstr[1])
            
            drawPinOnMap()
            fromMapsPins = false
            imageLabel.hidden = true
            
        }
        
        
        super.viewDidLoad()
        userID = false
        displayTime.hidden = true
        leaveNoteField.hidden = true
        addbuttonLabel.hidden = true
        addbuttonLabel.enabled = true
        totalTimeLabel.hidden = true
        totalTimeCountLabel.hidden = true
        totalDistCount.hidden = true
        totalDistanceLabel.hidden = true
        nameYourTripLabel.hidden = true
        tripNameInputField.hidden = true
        doneButtonLabel.hidden = true
        
        
        stopButtonLabel.setTitle("", forState: .Normal)
        stopButtonLabel.setTitleColor(UIColor.redColor(), forState: .Normal)
        
        userNameLabel.setTitle(defaults.stringForKey("firstName")!, forState: .Normal)
        imageLabel.layer.borderWidth = 1.0
        imageLabel.layer.masksToBounds = false
        imageLabel.layer.borderColor = UIColor.whiteColor().CGColor
        imageLabel.layer.cornerRadius = imageLabel.frame.size.width/2
        imageLabel.clipsToBounds = true
        
        
        let url = NSURL(string: defaults.stringForKey("imageUrl")!)
        
        NSURLSession.sharedSession().dataTaskWithURL(url!, completionHandler: { (data, response, error) -> Void in
            if error != nil {
                print(error)
                return
            }
            
            let image = UIImage(data: data!)
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.imageLabel.image = image
            })
            
        }).resume()
        
        
        
        self.locationManager.delegate = self
        mapView.delegate = self
        self.leaveNoteField.delegate = self;
       
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.requestAlwaysAuthorization()
 
        self.locationManager.distanceFilter = 0.02
        self.mapView.showsUserLocation = true
        self.mapView.showsBuildings = true
        
        
        
    }
    
    
    /////////Log out button ///////////
    @IBAction func logoutButtonPressed(sender: AnyObject) {
        let loginManager = FBSDKLoginManager()
        loginManager.logOut()
        
        let next = self.storyboard?.instantiateViewControllerWithIdentifier("LoginViewController") as! LoginViewController
        self.presentViewController(next, animated: true, completion: nil)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        
        let location = locations.last
        
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        
        _ = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))
        
        print(coordInd)
        
        
        coordinatepoints[coordInd].append(center)
        
        print(coordinatepoints)
        
        var passCoord = coordinatepoints[coordInd]
        
        if shouldDraw == true{
            let line = MKPolyline(coordinates: &passCoord, count: coordinatepoints[coordInd].count)
            self.mapView.addOverlay((line), level: MKOverlayLevel.AboveRoads)
        }
        
        
        
        //distance
        
        if(coordinatepoints[coordInd].count > 1){
            var from_coords = coordinatepoints[coordInd][coordinatepoints[coordInd].count - 2]
            var to_coords = coordinatepoints[coordInd][coordinatepoints[coordInd].count - 1]
            
            func distanceInMetersFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
                let firstLoc = CLLocation(latitude: from_coords.latitude, longitude: from_coords.longitude)
                let secondLoc = CLLocation(latitude: to_coords.latitude, longitude: to_coords.longitude)
                return firstLoc.distanceFromLocation(secondLoc)
            }
            distance += distanceInMetersFrom(to_coords)
            print("Distance in feet: ", distance)
        }
        
        
    }
    

    
    @IBAction func startButton(sender: UIButton) {
 
        if(startButtonLabel.currentTitle == "START"){
             userID = false
            reuseID = ""
           
            totalTimeLabel.hidden = true
            totalTimeCountLabel.hidden = true
            totalDistCount.hidden = true
            totalDistanceLabel.hidden = true
            nameYourTripLabel.hidden = false
            tripNameInputField.hidden = false
            doneButtonLabel.hidden = false
            
            
            startButtonLabel.setTitle("LEAVE NOTE", forState: .Normal)
            startButtonLabel.setTitleColor(UIColor.blueColor(), forState: .Normal)
            stopButtonLabel.setTitle("STOP", forState: .Normal)
            shouldDraw = true
            distance = 0.0
            
            print(tripName)
           
            
            
            self.locationManager.startUpdatingLocation()
            
            let currentLoc = self.locationManager
            
            let locationCoord = CLLocationCoordinate2D(latitude: (currentLoc.location?.coordinate.latitude)!,
                                                       longitude: (currentLoc.location?.coordinate.longitude)!)
            
            
            
            //Map zoom
            let region = MKCoordinateRegion(center: locationCoord, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            
            self.mapView.setRegion(region, animated: true)
            
            
            
            //Pin on map
            let Placemark = MKPlacemark(coordinate: locationCoord, addressDictionary: nil)
            _ = MKMapItem(placemark: Placemark)
            
            let Annotation = MKPointAnnotation()
            Annotation.title = "Trip #" + String(coordInd+1) + " Start"
            
            if let location = Placemark.location {
                Annotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([Annotation], animated: true )
            
        
            
            //Timer Start
            displayTime.hidden = false
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            
            
            
        }
        else if(startButtonLabel.currentTitle == "LEAVE NOTE"){
            
            leaveNoteField.hidden = false
            addbuttonLabel.hidden = false
            

            
        }
        else if(startButtonLabel.currentTitle == "START AGAIN"){
            reuseID = ""

            coordInd += 1
            coordinatepoints.append([CLLocationCoordinate2D]())
            shouldDraw = true
            userID = false
            nameYourTripLabel.hidden = false
            tripNameInputField.hidden = false
            doneButtonLabel.hidden = false
            tripName = tripNameInputField.text!
            
            if lineColor < 3{
                lineColor += 1
            }
            else{
                lineColor = 0
            }
            
            distance = tempDistance
            
            totalTimeLabel.hidden = true
            totalTimeCountLabel.hidden = true
            totalDistCount.hidden = true
            totalDistanceLabel.hidden = true
            
            startButtonLabel.setTitle("LEAVE NOTE", forState: .Normal)
            stopButtonLabel.setTitle("STOP", forState: .Normal)
            timer.invalidate()
            
           
            let aSelector : Selector = #selector(ViewController.updateTime)
            timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
            startTime = NSDate.timeIntervalSinceReferenceDate()
            

            let currentLoc = self.locationManager
            
            let locationCoord = CLLocationCoordinate2D(latitude: (currentLoc.location?.coordinate.latitude)!,
                                                       longitude: (currentLoc.location?.coordinate.longitude)!)
            
            //Map zoom
            let region = MKCoordinateRegion(center: locationCoord, span: MKCoordinateSpan(latitudeDelta: 0.001, longitudeDelta: 0.001))
            
            self.mapView.setRegion(region, animated: true)
            
            //Pin on map
            let Placemark = MKPlacemark(coordinate: locationCoord, addressDictionary: nil)
            _ = MKMapItem(placemark: Placemark)
            
            let Annotation = MKPointAnnotation()
            Annotation.title = "Trip #" + String(coordInd+1) + " Start"
            
            if let location = Placemark.location {
                Annotation.coordinate = location.coordinate
            }
            
            self.mapView.showAnnotations([Annotation], animated: true )
            
            //distance
            
            if(coordinatepoints[coordInd].count > 1){
                var from_coords = coordinatepoints[coordInd][coordinatepoints[coordInd].count - 2]
                var to_coords = coordinatepoints[coordInd][coordinatepoints[coordInd].count - 1]
                
                func distanceInMetersFrom(otherCoord : CLLocationCoordinate2D) -> CLLocationDistance {
                    let firstLoc = CLLocation(latitude: from_coords.latitude, longitude: from_coords.longitude)
                    let secondLoc = CLLocation(latitude: to_coords.latitude, longitude: to_coords.longitude)
                    return firstLoc.distanceFromLocation(secondLoc)
                }
                distance += distanceInMetersFrom(to_coords)
                 print("Distance in meters: ", distance)
            }
            
        }
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    
    ////////DONE BUTTON///////////////
    @IBAction func DoneButtonPressed(sender: AnyObject) {
        if( tripNameInputField.text != ""){
        nameYourTripLabel.hidden = true
        tripNameInputField.hidden = true
        doneButtonLabel.hidden = true
        tripName = tripNameInputField.text!
        print(tripName)

        textFieldShouldReturn(tripNameInputField)
        } else {
            let alert = UIAlertController(title: "", message: "Please specify a name for your trip", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default)
            {
                (UIAlertAction) -> Void in
            }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true)
            {
                () -> Void in 
            }
            
        }
    }
    
    
    
    @IBAction func addTextButton(sender: UIButton) {
        showNote = leaveNoteField.text
        if (showNote != ""){
            
            let pinCoord = String(coordinatepoints[coordInd][coordinatepoints[coordInd].count - 1])
            postPin(pinCoord,username: defaults.stringForKey("UserId")!,note: showNote!)
            
            leaveNoteField.text = ""
            leaveNoteField.hidden = true
            addbuttonLabel.hidden = true
            userID = true
            textFieldShouldReturn(leaveNoteField)
            
        } else {
            let alert = UIAlertController(title: "", message: "Please write a note for your pin", preferredStyle: UIAlertControllerStyle.Alert)
            let alertAction = UIAlertAction(title: "OK!", style: UIAlertActionStyle.Default)
            {
                (UIAlertAction) -> Void in
            }
            alert.addAction(alertAction)
            presentViewController(alert, animated: true)
            {
                () -> Void in
            }
            
        }
        
    
        let currentLoc = self.locationManager
        
        
        let locationCoord = CLLocationCoordinate2D(latitude: (currentLoc.location?.coordinate.latitude)!,
                                                   longitude: (currentLoc.location?.coordinate.longitude)!)
        
        
        //Pin on map
        let Placemark = MKPlacemark(coordinate: locationCoord, addressDictionary: nil)
        _ = MKMapItem(placemark: Placemark)
        
        let Annotation = MKPointAnnotation()
        Annotation.title = showNote
        
        
        if let location = Placemark.location {
            Annotation.coordinate = location.coordinate
        }
        
        self.mapView.showAnnotations([Annotation], animated: true )
        
        
    }
    
    func secondsToHoursMinutesSeconds (seconds : Int) -> (Int, Int, Int) {
        return (seconds / 3600, (seconds % 3600) / 60, (seconds % 3600) % 60)
    }
    
    
    func printSecondsToHoursMinutesSeconds (seconds:Int) -> String {
        let (h, m, s) = secondsToHoursMinutesSeconds (seconds)
        return "\(h)h \(m)m \(s)s"
    }
    
    @IBAction func stopButton(sender: UIButton) {
        
       
        if(stopButtonLabel.currentTitle == "STOP"){
            
            totalTimeLabel.hidden = false
            totalTimeCountLabel.hidden = false
            totalDistCount.hidden = false
            totalDistanceLabel.hidden = false
            leaveNoteField.hidden = true
            addbuttonLabel.hidden = true
            nameYourTripLabel.hidden = true
            tripNameInputField.hidden = true
            doneButtonLabel.hidden = true
            tripNameInputField.text = ""
           
            
            userID = false
            
            shouldDraw = false
            
            totalTime += showTime
            //print(totalTime)
            
            
            totalTimeCountLabel.text = printSecondsToHoursMinutesSeconds(totalTime)
            
            tripDistance = distance - tempDistance
            
            tempDistance = distance
            
            
            var totalMiles = Int(distance/1609.34)
            var totalFeet = Int((distance * 3.28) % 1609)
            
            let botLabelText: String = String(totalMiles) + "mi " + String(totalFeet) + "ft"
            
            totalDistCount.text = botLabelText
          
            
            
            startButtonLabel.setTitle("START AGAIN", forState: .Normal)
            stopButtonLabel.setTitle("RESET", forState: .Normal)
            
            let currentLoc = self.locationManager
            
            
            let locationCoord = CLLocationCoordinate2D(latitude: (currentLoc.location?.coordinate.latitude)!,
                                                       longitude: (currentLoc.location?.coordinate.longitude)!)
            
            
            let Placemark = MKPlacemark(coordinate: locationCoord, addressDictionary: nil)
            
            _ = MKMapItem(placemark: Placemark)
            
            let Annotation = MKPointAnnotation()
            Annotation.title = "Trip #" + String(coordInd + 1) + " End"
            
            
            let miles = Int(tripDistance/1609.34)
            let feet = Int((tripDistance * 3.28) % 1609)
            
            let endPointText: String = "Trip Distance: " + String(miles) + "mi " + String(feet) + "ft"
            
            
            if let location = Placemark.location {
                Annotation.coordinate = location.coordinate
                Annotation.subtitle = endPointText
            }
            
            self.mapView.showAnnotations([Annotation], animated: true )
            
            timer.invalidate()
        
            
            // Posting trip info
            let testCoord = coordinatepoints[coordinatepoints.count-1]
            var coordString = ""
            
            for (var i=0; i < testCoord.count; i += 1){
                coordString += String(testCoord[i])
                if( i < testCoord.count - 1){
                    coordString += "?"
                }
            }
            
            let FBuserID = defaults.stringForKey("UserId")
            
            postTrip(tripName, trip: coordString, distance: botLabelText, duration: String(showTime), userId: FBuserID!)
            
        }
        else if(stopButtonLabel.currentTitle == ""){
            
        }
        else if(stopButtonLabel.currentTitle == "RESET"){
            
            shouldDraw = false
            userID = false
            
            coordinatepoints = [[CLLocationCoordinate2D]()]
            coordInd = 0
            
            
            totalTimeLabel.hidden = true
            totalTimeCountLabel.hidden = true
            leaveNoteField.hidden = true
            addbuttonLabel.hidden = true
            totalDistCount.hidden = true
            totalDistanceLabel.hidden = true
            doneButtonLabel.hidden = true
            
            
            startButtonLabel.setTitle("START", forState: .Normal)
            stopButtonLabel.setTitle("", forState: .Normal)
            
            
            
            totalTime = 0
            
            //deleting overlays
            self.mapView.overlays.forEach {
                if !($0 is MKUserLocation) {
                    self.mapView.removeOverlay($0)
                }
            }
            
            
            //removing pins
            mapView.removeAnnotations(mapView.annotations)
            
            
            
            displayTime.hidden = true
        }
        
        
    }
    
    
    
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        
        var colorArr = [UIColor.blueColor(), UIColor.redColor(), UIColor.greenColor(), UIColor.yellowColor()]
        
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = colorArr[lineColor]
        renderer.lineWidth = 4.0
        
        return renderer
    }
    
    
    
    //Timer shit
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
    
        //Find the difference between current time and start time.
        var elapsedTime: NSTimeInterval = currentTime - startTime
        
        showTime = Int(elapsedTime)
        //print(elapsedTime)
        
        //calculate the minutes in elapsed time.
        let minutes = UInt8(elapsedTime / 60.0)
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        
        //calculate the seconds in elapsed time.
        let seconds = UInt8(elapsedTime)
        elapsedTime -= NSTimeInterval(seconds)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        
        //concatenate minuets, seconds and milliseconds as assign it to the UILabel
        
        lastTime = "\(strMinutes):\(strSeconds)"
        
        displayTime.text = lastTime
        
    }
    
    
}

