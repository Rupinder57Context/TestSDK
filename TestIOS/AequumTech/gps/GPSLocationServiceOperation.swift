//
//  GPSLocationServiceOperation.swift
//  AequumFramework
//
//  Created by Aleksandar Matijaca on 2019-10-31.
//  Copyright © 2019 Polyorb Inc. All rights reserved.
//

import Foundation
import CoreLocation

class GPSLocationServiceOperation: Operation {
    
    var currentLocation: CLLocation!

    let locManager = CLLocationManager()
    var timer: Timer!

    override func main() {
        // starting Location Service Provider...
        print("starting gps location provider")
        
        locManager.delegate = self
        locManager.startMonitoringSignificantLocationChanges()
//        locManager.distanceFilter = 10.0
        locManager.activityType = .automotiveNavigation
        locManager.desiredAccuracy = kCLLocationAccuracyBest
        locManager.requestWhenInUseAuthorization()
        locManager.allowsBackgroundLocationUpdates = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.stopGPS(_:)), name: Notification.Name(Constants.kAEStopGPS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.startGPS(_:)), name: Notification.Name(Constants.kAEStartGPS), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.backgroundedGPS(_:)), name: Notification.Name(Constants.kAEEnterBackground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.foregroundedGPS(_:)), name: Notification.Name(Constants.kAEEnterForeground), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.statusGPS(_:)), name: Notification.Name(Constants.kAEGPSStatus), object: nil)
        
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: (4.0/60.0), target: self, selector: #selector(self.timedLocationAndSpeed), userInfo: nil, repeats: true)
            self.timer.fire()
        }

        while(true) {

            sleep(10)
            print("gps tic/toc")

        }
    }

    @objc func timedLocationAndSpeed() {
        guard currentLocation != nil else {
            return
        }

        print("lat: \(currentLocation.coordinate.latitude) long: \(currentLocation.coordinate.longitude) speed: \(currentLocation.speed)")
        let aeLocation = AEMotionEntity()
        aeLocation.latitude = currentLocation.coordinate.latitude
        aeLocation.longitude = currentLocation.coordinate.longitude
        aeLocation.speed = currentLocation.speed
        aeLocation.timestamp = Date()

        let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil, userInfo: [Constants.kAELocation: aeLocation as Any])
            
    }
    
    @objc func statusGPS(_ notification:Notification) {
        print("TODO: gps status")
    }
    
    @objc func backgroundedGPS(_ notification:Notification) {
        locManager.stopUpdatingLocation()
        locManager.startMonitoringSignificantLocationChanges()
        AEPopupNotif.shared.addNotification(title: "Backgrounded, sgnificant GPS only.")

    }

    @objc func foregroundedGPS(_ notification:Notification) {
        print("starting updating going to foreground")
        locManager.startUpdatingLocation()
        locManager.stopMonitoringSignificantLocationChanges()
        AEPopupNotif.shared.addNotification(title: "Regular Location Monitoring")
    }

    
    @objc func stopGPS(_ notification:Notification) {
        locManager.stopUpdatingLocation()

    }

    @objc func startGPS(_ notification:Notification) {
        locManager.startUpdatingLocation()

    }

        
}

extension GPSLocationServiceOperation: CLLocationManagerDelegate {
   
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if( status ==  .authorizedWhenInUse ){
            locManager.requestAlwaysAuthorization()
        } else if status == .notDetermined {
            locManager.requestWhenInUseAuthorization()
        } else if status == .authorizedAlways {
            print("we good..")
        }

    }
    
   func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        for location in locations {
            currentLocation = location
            print("dlat: \(location.coordinate.latitude) dlong: \(location.coordinate.longitude) speed: \(location.speed)")
            let aeLocation = AEMotionEntity()
            aeLocation.latitude = location.coordinate.latitude
            aeLocation.longitude = location.coordinate.longitude
            aeLocation.speed = location.speed
            aeLocation.timestamp = Date()
            
            let _ = NotificationCenter.default.post(name: Notification.Name(Constants.kAETimedLocationAndSpeed), object: nil, userInfo: [Constants.kAELocation: aeLocation as Any])
        }
    
    }
    
}
