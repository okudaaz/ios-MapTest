//
//  ViewController.swift
//  MapTest
//
//  Created by Eiji Okuda on 11/12/15.
//  Copyright © 2015 Eiji Okuda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    var myLocationManager:CLLocationManager!
    var locationModel:MapLocationModel = MapLocationModel();
    var lastDate:NSDate!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        myLocationManager = CLLocationManager();
        myLocationManager.delegate = self
        
        myLocationManager.requestAlwaysAuthorization()
        myLocationManager.desiredAccuracy = kCLLocationAccuracyBest
        myLocationManager.distanceFilter = 5
        
        myLocationManager.startUpdatingLocation()
        
        mapView.delegate = self;
        
        lastDate = NSDate()
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
        
        let location = CLLocationCoordinate2D(
            latitude: latitude,
            longitude: longitude
        )

        locationModel.locations.append(location)

        // Calcurate speed
        let deltaSecond = NSDate().timeIntervalSinceDate(lastDate)
        let distanceMeter = newLocation.distanceFromLocation(oldLocation)
        let speed = (distanceMeter / 1000) / (deltaSecond / 3600)
        if(locationModel.locations.count > 1){
            locationModel.speed.append(speed)
        } else {
            locationModel.speed.append(0.0)
        }
        
        // Show Poly Line
        showPolyLine()
        
        print("Location = {\(latitude), \(longitude)}, Distance = \(distanceMeter), Second = \(deltaSecond), Speed = \(speed), #\(locationModel.locations.count)")
        
        lastDate = NSDate()
        
        /*
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Current Position"
        annotation.subtitle = "My Home"
        mapView.addAnnotation(annotation)
        */
        
    }

    func showPolyLine(){
        
        let locations = locationModel.locations
        
        let polyLine = MKPolyline(coordinates: &locationModel.locations[0], count: locations.count)
        mapView.addOverlay(polyLine)
        
        if(locations.count == 1){
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let region = MKCoordinateRegion(center: locations[0], span: span)
            mapView.setRegion(region, animated: true)
        }
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay overlay: MKOverlay!) -> MKOverlayRenderer! {
        
        if overlay is MKPolyline {
            var polylineRenderer = MKPolylineRenderer(overlay: overlay)
            polylineRenderer.strokeColor = UIColor.blueColor()
            polylineRenderer.lineWidth = 5
            return polylineRenderer
        }
    
        return nil
    }
    
    /** 位置情報取得失敗時 */
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        NSLog("Error")
    }
    
    @IBOutlet weak var mapView: MKMapView!

}

