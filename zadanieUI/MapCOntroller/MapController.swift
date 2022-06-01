//
//  MapController.swift
//  zadanieUI
//
//  Created by Timotej Čery on 18/05/2022.
//

import Foundation
import UIKit
import MapKit

class MapController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBAction func showCustomeWeather(_ sender: Any) {
        presentDetailCustomeWeather()
    }
    private var geocoder = CLGeocoder()
    
    var myPlacemarks: CLPlacemark?
    var place = Place(city: "Prievidza", country: "Slovensko")
    var defaulPlace : Place = Place.init(city: "Prievidza", country: "Slovensko")
    let regionInMeter:Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shered.getLocation(completion: LocationManager.shered.completion)
        LocationManager.shered.userMapLocation = self
    }
    
    func presentDetailCustomeWeather() {
        print(myPlacemarks?.location?.coordinate ?? "")
        print(myPlacemarks?.locality)
//        self.place.city = (myPlacemarks?.locality)!
//        self.place.country = (myPlacemarks?.country)!
        self.presentCustomDetailWeather(with: self.place)
    }
    
    func presentCustomDetailWeather(with place: Place) {
        let storyboard = UIStoryboard(name: "DetailViewController", bundle: nil)
        if let weatherViewController = storyboard.instantiateViewController(withIdentifier: "WeatherDetail") as? ViewController {
            weatherViewController.place = place
            navigationController?.pushViewController(weatherViewController, animated: true)
        }
    }
}


extension MapController: LocationManagerMapDelegate {
    func locationManager(_locationManager: LocationManager, didLoadMapLocation mapLocation: String) {
        print("region map controller")
        mapView.showsUserLocation = true
        let region = MKCoordinateRegion.init(center: LocationManager.shered.location!.coordinate, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = LocationManager.shered.getCenterLocation(for: mapView)
        
        guard let previousLocation = LocationManager.shered.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 10 else { return }
        
        LocationManager.shered.previousLocation = center
        
        geocoder.reverseGeocodeLocation(center) { [ weak self] placemarks, error in
            guard let self = self , error == nil , let placemark = placemarks?.first else{ return }
            
            self.myPlacemarks = placemark
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let mapLat = placemark.location?.coordinate.latitude
            let mapLon = placemark.location?.coordinate.longitude
//            print(" lat \(mapLat) , lon \(mapLon)")
            self.addressLabel.text = "\(streetName) \(streetNumber)"
        }
    }
}
