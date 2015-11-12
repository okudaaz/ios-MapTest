//
//  ViewController.swift
//  MapTest
//
//  Created by Eiji Okuda on 11/12/15.
//  Copyright © 2015 Eiji Okuda. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, CLLocationManagerDelegate {

    var myLocationManager:CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationManager = CLLocationManager();
        myLocationManager.delegate = self
        
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 5
        
        myLocationManager.startUpdatingLocation()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus){
        print("didChangeAuthorizationStatus")
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation){
        
        let longitude = newLocation.coordinate.longitude
        let latitude = newLocation.coordinate.latitude
        
        print("Location = {\(latitude), \(longitude)}")
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )
        
        let span = MKCoordinateSpanMake(0.05, 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Current Position"
        annotation.subtitle = "My Home"
        mapView.addAnnotation(annotation)
        
    }
    
    /** 位置情報取得失敗時 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }
    
    @IBOutlet weak var mapView: MKMapView!

}

