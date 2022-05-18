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
typealias AuthorizationHandler = ((Bool) -> Void)

class LocationManager : CLLocationManager{
    static let shered  = LocationManager()
    
    private var geoCoder = CLGeocoder()
    
    var denied : Bool {
        LocationManager.shered.authorizationStatus == .denied
    }
    
    weak var cityDelegate: LocationManagerDelegate?
    
    var completion: CityCompletionHandler?
    var authorizationCompletion: AuthorizationHandler?
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
    func onAuthorizationChange(completion: @escaping AuthorizationHandler) {
        authorizationCompletion = completion
    }
    

}


//MARK: LOCATION MANAGER DELEGATE
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
            self.stopUpdatingLocation()
        }
    }
  
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        print(manager.authorizationStatus)
        switch manager.authorizationStatus {
        case .denied:
            authorizationCompletion?(false)
        case .authorizedWhenInUse , .authorizedAlways:
            authorizationCompletion?(true)
        case .notDetermined:
            print("Not yet")
        case .restricted:
            print("Restricted")
        @unknown default:
            fatalError()
        }
    }
}
