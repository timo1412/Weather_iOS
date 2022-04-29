//
//  WeatherRequest.swift
//  zadanieUI
//
//  Created by Timotej Čery on 25/04/2022.
//

import Foundation


struct WeatherRequest : Encodable {
    let latitude : String
    let lontitude : String
    let exclude : String
    let appiId : String
    let units : String
    
    enum CodingKeys: String , CodingKey {
        
        case latitude = "lat"
        case lontitude = "lon"
        case appiId = "appid"
        case units,exclude
    }

}
