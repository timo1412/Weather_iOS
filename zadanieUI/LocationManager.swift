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


protocol LocationManagerDelegate: NSObject  {
    func locationManager(_ locationManager: LocationManager, didLoadCurrent location: CurrentLocation)
}

typealias CityCompletionHandler = ((CurrentLocation? , Error?) -> Void)
typealias LocalSearchCompletionHandler = (([Place]) -> Void)

class LocationManager : CLLocationManager{
    static let shered  = LocationManager()
    private var geoCoder = CLGeocoder()
    private let searchCompleter = MKLocalSearchCompleter()
    
    var searchCompletion:LocalSearchCompletionHandler?
    
    weak var cityDelegate: LocationManagerDelegate?
    var completion: CityCompletionHandler?
    
    func getLocation(completion: CityCompletionHandler?) {
        self.completion = completion
        requestWhenInUseAuthorization()
        startUpdatingLocation()
        delegate = self
    }
    
//    nadstavenie searchCompletera typ vyhladavania aj to pomocou akých dat vyhladavame v tomto pripade query = string 
    func getLocalSearchResult(from query : String, completion: @escaping LocalSearchCompletionHandler){
        self.searchCompletion = completion
        searchCompleter.resultTypes = .address
        searchCompleter.queryFragment = query
        searchCompleter.delegate = self
        
        
    }
}

struct Place {
    let city : String
    let country : String
}

//z completer result dostaneme ako objekty vyhladane miesta , place.title vypisuje ako string Nazov mesta a štátu okresy kraje ATD.
extension LocationManager: MKLocalSearchCompleterDelegate{
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        
        //        prechadza to čo nam vrati completer ersult pozrie sa či nie je prazdny ak nie je tak jeho componenty rozdely podla čiarky , a ak je počet komponentov väčší ako jeden tak z čoho vyplýva že to bude mesto zo štátom tak vytvori Place s mestom a daným štátom
        let places = completer.results
            .filter{ !$0.title.isEmpty }
            .map{$0.title.components(separatedBy: ",")}
            .filter{$0.count>1}
            .map{ Place( city : $0[0], country : $0[1]) }
        searchCompletion?(places)
        print(places)
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
