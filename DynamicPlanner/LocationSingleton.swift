//
//  LocationSingleton.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 4/11/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import CoreLocation

protocol LocationUpdateDelegate {
    func locationDidUpdateToLocation(location : CLLocation)
}

let kLocationDidChangeNotification = "LocationDidChangeNotification"

class LocationSingleton: NSObject, CLLocationManagerDelegate {
    var locationManager: CLLocationManager?
    var lastLocation: CLLocation?
    var delegate : LocationUpdateDelegate!
    
    static let shared: LocationSingleton = {
        let instance = LocationSingleton()
        return instance
    }()
    
    override init() {
        super.init()
        self.locationManager = CLLocationManager()
        
        guard let locationManagers = self.locationManager else {
            return
        }
        
        if CLLocationManager.authorizationStatus() == .notDetermined {
            locationManagers.requestAlwaysAuthorization()
            locationManagers.requestWhenInUseAuthorization()
        }
//        if #available(iOS 9.0, *) {
//            locationManagers.allowsBackgroundLocationUpdates = true
//        } else {
//            // fallback on ealrier versions
//        }
        
        locationManagers.desiredAccuracy = kCLLocationAccuracyBest
        locationManagers.pausesLocationUpdatesAutomatically = false
        locationManagers.distanceFilter = 0.1
        locationManagers.delegate = self
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(locations.last == nil)
        {
            return
        }
        
        guard let location = locations.last else {
           
            return
        }
        
        self.lastLocation =  location
        DispatchQueue.main.async {
           // either call delegate or send notification
            self.delegate.locationDidUpdateToLocation(location: self.lastLocation!)
        }
    }
    
    func startUpdatingUserLocation() {
        locationManager?.startUpdatingLocation()
    }
    func stopUpdatingUserLocation() {
        locationManager?.stopUpdatingLocation()
    }
    
    @nonobjc func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            locationManager?.requestAlwaysAuthorization()
            break
        case .authorizedWhenInUse:
            locationManager?.startUpdatingLocation()
            break
        case .authorizedAlways:
            locationManager?.startUpdatingLocation()
            break
        case .restricted:
            // cannot enable location services
            break
        case .denied:
            // user denied app access to location services
            break
        default:
            break
        }
    }
    
    func isLocationServicesEnabled() -> Bool {
        return CLLocationManager.locationServicesEnabled()
    }
}
