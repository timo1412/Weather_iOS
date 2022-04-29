//
//  LocationManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 10/04/2022.
//

import Foundation
import CoreLocation

struct CurrentLocation {
    let city: String
    let coordinates: CLLocationCoordinate2D
}


protocol LocationManagerDelegate: NSObject  {
    func locationManager(_ locationManager: LocationManager, didLoadCurrent location: CurrentLocation)
}

typealias CityCompletionHandler = ((CurrentLocation? , Error?) -> Void)

class LocationManager : CLLocationManager{
    static let shered  = LocationManager()
    private var geoCoder = CLGeocoder()
    
    weak var cityDelegate: LocationManagerDelegate?
    var completion: CityCompletionHandler?
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
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
        geoCoder.reverseGeocodeLocation(location) { [weak self] placemarks , error in
            guard let self = self else {return  }
            
            guard let placemark = placemarks?.first ,let city = placemark.locality , error == nil else {
                if let completion = self.completion {
                    completion(nil , error)
                }
                return
            }
            let currentLocation = CurrentLocation ( city: city, coordinates:location.coordinate)
            self.completion?(currentLocation , nil)
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
