//
//  LocationManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 10/04/2022.
//

import Foundation
import CoreLocation
import MapKit

struct CurrentLocation {
    let city: String
    let coordinates: CLLocationCoordinate2D
}

protocol LocationStreetManagerDelegate : NSObject {
    func locationManager(_ locationManager: LocationManager, didLoadLocation mapLocation: String)
}
protocol LocationManagerMapDelegate : NSObject {
    func locationManager(_locationManager: LocationManager, didLoadMapLocation mapLocation: String)
}
protocol LocationManagerDelegate: NSObject  {
    func locationManager(_locationManager: LocationManager, didLoadCurrent location: CurrentLocation)
}

typealias CityCompletionHandler = ((CurrentLocation? , Error?) -> Void)
typealias AuthorizationHandler = ((Bool) -> Void)

class LocationManager : CLLocationManager{
    static let shared  = LocationManager()
    private var geoCoder = CLGeocoder()
    var previousLocation: CLLocation?
    weak var charLocation: LocationManagerDelegate?
    weak var userMapLocation: LocationManagerMapDelegate?
    var denied : Bool {
        LocationManager.shared.authorizationStatus == .denied
    }
    
    weak var cityDelegate: LocationManagerDelegate?
    
    var completion: CityCompletionHandler?
    var authorizationCompletion: AuthorizationHandler?
    
    func getPlaceLocation(where place : Place , completion: @escaping(CurrentLocation?, Error?) -> Void){
        let addres = place.country + ", " + place.city
        geoCoder.geocodeAddressString(addres) { placemarks, error in
            guard let placemark = placemarks?.first, let location = placemark.location, error == nil else {
                completion(nil,error)
                return
            }
            
            let coordinates = location.coordinate
            completion(CurrentLocation(city: place.city, coordinates: coordinates),nil)
        }
    }
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
    func onAuthorizationChange(completion: @escaping AuthorizationHandler) {
        authorizationCompletion = completion
    }
    
    func getCenterLocation(for mapView: MKMapView)->CLLocation{
        let latitude = mapView.centerCoordinate.latitude
        let lontitude = mapView.centerCoordinate.longitude
        
        return CLLocation(latitude: latitude, longitude: lontitude)
    }
}


//MARK: LOCATION MANAGER DELEGATE
extension LocationManager : CLLocationManagerDelegate{
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        print(locations)
        guard let location = locations.last else{
            return
        }
        print(location)
        previousLocation = location
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
            self.userMapLocation?.locationManager(_locationManager: self, didLoadMapLocation: city)
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


