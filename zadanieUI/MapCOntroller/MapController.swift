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
//    MARK:OUTLETS
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addressLabel: UILabel!
//    MARK:BUTTONS
    @IBAction func showCustomeWeather(_ sender: Any) {
        presentDetailCustomeWeather()
    }
//    MARK:VARIABLES
    private var geocoder = CLGeocoder()
    var myPlacemarks: CLPlacemark?
    var place = Place(city: "Prievidza", country: "Slovensko")
    
    let regionInMeter:Double = 10000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shared.getLocation(completion: LocationManager.shared.completion)
        LocationManager.shared.userMapLocation = self
    }
    
    func presentDetailCustomeWeather() {
        place.city = (myPlacemarks?.locality) ?? place.city
        place.country = (myPlacemarks?.country) ?? place.country
        
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
        mapView.showsUserLocation = true
        
        let region = MKCoordinateRegion.init(center: LocationManager.shared.location!.coordinate, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
    }
}

extension MapController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        
        let center = LocationManager.shared.getCenterLocation(for: mapView)
        
        guard let previousLocation = LocationManager.shared.previousLocation else { return }
        
        guard center.distance(from: previousLocation) > 10 else { return }
        
        LocationManager.shared.previousLocation = center
        
        geocoder.reverseGeocodeLocation(center) { [ weak self] placemarks, error in
            guard let self = self , error == nil , let placemark = placemarks?.first else{ return }
            
            self.myPlacemarks = placemark
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""

            self.addressLabel.text = "\(streetName) \(streetNumber)"
        }
    }
}
