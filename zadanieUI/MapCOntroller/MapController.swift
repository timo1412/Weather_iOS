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
    private var geocoder = CLGeocoder()
    weak var streetMapLocation: LocationStreetManagerDelegate?
    let regionInMeter:Double = 10000
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager.shered.getLocation(completion: LocationManager.shered.completion)
        LocationManager.shered.userMapLocation = self
        
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
            
            let streetNumber = placemark.subThoroughfare ?? ""
            let streetName = placemark.thoroughfare ?? ""
            let mapLat = placemark.location?.coordinate.latitude
            let mapLon = placemark.location?.coordinate.longitude
            print(" lat \(mapLat) , lon \(mapLon)")
            self.addressLabel.text = "\(streetName) \(streetNumber)"
        }
    }
}
