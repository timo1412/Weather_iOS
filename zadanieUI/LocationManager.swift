//
//  LocationManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 10/04/2022.
//

import Foundation
import CoreLocation

class LocationManager : CLLocationManager{
    static let shered  = LocationManager()
    private var geoCoder = CLGeocoder()
    func getLocation() {
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
}

extension LocationManager : CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
        guard let location = locations.last else{
            return
        }
        geoCoder.reverseGeocodeLocation(location) { placemarks , error in
            guard let placemark = placemarks?.first ,let city = placemark.locality , error == nil else {
                return
            }
            print(city)
        }
            
    }

    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print(manager.authorizationStatus)
        switch manager.authorizationStatus {
        case .denied:
            print("denied")
        case .authorizedWhenInUse , .authorizedAlways:
            print("Authorized")
        case .notDetermined:
            print("Not yet")
        case .restricted:
            print("Restricted")
        @unknown default:
            fatalError()
        }
    }
}
