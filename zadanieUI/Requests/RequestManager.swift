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
    
    
    func getHourlyWeather(for coordinate: CLLocationCoordinate2D , completion : @escaping (Result<WeatherResponse,AFError>)->Void) {
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
            .validate().responseDecodable(of: WeatherResponse.self , decoder: decoder) { response in
                completion(response.result)
            }
    }
    
    func getWeatherData(for coordinate : CLLocationCoordinate2D , completion: @escaping (Result<WeatherResponse, AFError>) -> Void) {
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
        //        validacia rieši či status je v range od 200 do 299
            .validate()
            .responseDecodable(of: WeatherResponse.self , decoder: decoder) { response in
//                print(response.request?.url)
                completion(response.result)
            }
    }
}
