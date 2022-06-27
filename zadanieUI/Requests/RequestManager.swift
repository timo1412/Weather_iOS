//
//  RequestManager.swift
//  zadanieUI
//
//  Created by Timotej Čery on 24/04/2022.
//

import Foundation
import CoreLocation
import Alamofire

struct RequestManager {
    static let shered = RequestManager()
    
    
    func getHourlyWeather(for coordinate: CLLocationCoordinate2D , completion : @escaping (Result<HourlyResponse,AFError>)->Void) {
        let request = WeatherRequest(
            latitude: "\(coordinate.latitude)",
            lontitude: "\(coordinate.longitude)",
            exclude: "minutely",
            appiId: "9f5dd8ad1cd998fb081b543014b559f6",
            units: "metric"
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request)
            .validate()
            .responseDecodable(of: HourlyResponse.self , decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func getDailyWeather(for coordinate: CLLocationCoordinate2D , completion : @escaping (Result<DailyResponse,AFError>)->Void) {
        let request = WeatherRequest(
            latitude: "\(coordinate.latitude)",
            lontitude: "\(coordinate.longitude)",
            exclude: "minutely",
            appiId: "9f5dd8ad1cd998fb081b543014b559f6",
            units: "metric"
        )
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        
        AF.request("https://api.openweathermap.org/data/2.5/onecall", method: .get, parameters: request)
            .validate()
            .responseDecodable(of: DailyResponse.self , decoder: decoder) { response in
                completion(response.result)
            }
    }
}
