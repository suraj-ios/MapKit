//
//  ViewController.swift
//  SolulabTestProject
//
//  Created by Suraj on 05/01/19.
//  Copyright © 2019 Suraj. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import UserNotifications

class ViewController: UIViewController,CLLocationManagerDelegate,MKMapViewDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var travelledDistanceLabel: UILabel!
    var locationManager: CLLocationManager!
    
    @IBOutlet weak var starStopLocationButton: UIBarButtonItem!
    
    var initialLatLongBool:Bool = false
    var appd:AppDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var travelledData:[TravelledListDataModel] = [TravelledListDataModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if (CLLocationManager.locationServicesEnabled())
        {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.allowsBackgroundLocationUpdates = true
            locationManager.pausesLocationUpdatesAutomatically = false
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
        self.map.showsUserLocation = true
        self.map.mapType = MKMapType.standard
        
        self.starStopLocationButton.title = "Stop"
     
        NotificationCenter.default.addObserver(self, selector: #selector(ViewController.openListDataPage), name: Notification.Name(rawValue: "OpenListPage"), object: nil)
        
    }

    @objc func openListDataPage(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let destination = storyBoard.instantiateViewController(withIdentifier: "TravelledListDataViewController") as! TravelledListDataViewController
        
        if let data = UserDefaults.standard.data(forKey: "travelledData"),
            let myPeopleList = NSKeyedUnarchiver.unarchiveObject(with: data) as? [TravelledListDataModel] {
            destination.travelledListData.removeAll()
            destination.travelledListData = myPeopleList
        } else {
            print("There is an data")
        }
        let navBar = UINavigationController(rootViewController: destination)
        self.present(navBar, animated: true, completion: nil)
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            
            //create region of current location
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.map.setRegion(region, animated: true) // end here
            
            
            //Show address of current user location
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(location) { (placemarks, error) in
                if (error != nil){
                }
                if (placemarks) != nil
                {
                    let placemark = placemarks! as [CLPlacemark]
                    if placemark.count>0{
                        let placemark = placemarks![0]
                    
                    let adress = (placemark.thoroughfare != nil) ? placemark.thoroughfare : "adress: "
                    let subAddress = (placemark.subThoroughfare != nil) ? placemark.subThoroughfare : "subAddress:"
                    let locality = (placemark.locality != nil) ? placemark.locality : "locality: "
                    let subLocality = (placemark.subLocality != nil) ? placemark.subLocality : "subLocality: "
                    let country = (placemark.country != nil) ? placemark.country : "country: "
                    let postalCode = (placemark.postalCode != nil) ? placemark.postalCode : "postalCode: "
                    
                    let theLocation: MKUserLocation = self.map.userLocation
                    theLocation.title = "\(subAddress! + ", " + adress! + ", " + subLocality!)"
                    theLocation.subtitle = "\(locality! + ", " + country! + ", " + postalCode!)"
                    
                    }
                }
            }// end here
            
            //Calculate travelled distance of current user location
            if self.initialLatLongBool == false{
                self.initialLatLongBool = true
                self.appd.initialLatValue = location.coordinate.latitude
                self.appd.initialLongValue = location.coordinate.longitude
            }
            self.calculateTravelledDistance(location.coordinate.latitude, location.coordinate.longitude)
            // end here
        }
    }
    
    func calculateTravelledDistance(_ currentLatValue:Double, _ CurrentLongValue:Double){
        let loc1 = CLLocation(latitude: currentLatValue, longitude: CurrentLongValue)
        let loc2 = CLLocation(latitude: self.appd.initialLatValue, longitude: self.appd.initialLongValue)
        
        let distanceInMeters = loc1.distance(from: loc2)
        
        let distance = String(format: "%.2f", distanceInMeters)
        self.travelledDistanceLabel.text = distance + " meter(s)"
        
        if distanceInMeters >= 50{
            self.appd.initialLatValue = currentLatValue
            self.appd.initialLongValue = CurrentLongValue
            
            let currentDateTime = Date()
            let formatter = DateFormatter()
            formatter.timeStyle = .medium
            formatter.dateStyle = .long
            let dateTime = formatter.string(from: currentDateTime)
            
            let obj = TravelledListDataModel(distance , dateTime)
            self.travelledData.append(obj)
            
            let tasksDetailsObj = NSKeyedArchiver.archivedData(withRootObject: self.travelledData)
            UserDefaults.standard.set(tasksDetailsObj, forKey: "travelledData")
            
            let notificationContent = UNMutableNotificationContent()
            notificationContent.title = "A car travels 50 meters"
            notificationContent.body = "Alert"
            notificationContent.sound = UNNotificationSound.default
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let notificationRequest = UNNotificationRequest(identifier: UUID().uuidString, content: notificationContent, trigger: trigger)
            
            UNUserNotificationCenter.current().add(notificationRequest, withCompletionHandler: { (error) in
                if let error = error {
                    print(error)
                }else{
                    print("local push scheduled!")
                }
            })
        }
    }
    
    var startStopLocationUpdate:Bool = false
    @IBAction func startStopLocationButtonAction(_ sender: Any) {
        
        if self.startStopLocationUpdate == false{
            self.startStopLocationUpdate = true
            self.starStopLocationButton.title = "Start"
            self.locationManager.stopUpdatingLocation()
        }else{
            self.startStopLocationUpdate = false
            self.starStopLocationButton.title = "Stop"
            self.locationManager.startUpdatingLocation()
        }
    }
    
}

