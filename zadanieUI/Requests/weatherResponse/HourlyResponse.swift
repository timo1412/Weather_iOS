////
////  HourlyResponse.swift
////  zadanieUI
////
////  Created by Timotej Čery on 25/05/2022.
////
//
//import Foundation
//import UIKit


import Foundation
import UIKit

// MARK: - Welcome
struct HourlyResponse: Decodable {
    let current: Current
    let hourly: [Current]

    enum CodingKeys: String, CodingKey {
        case current
        case hourly
    }
}

// MARK: - Current
struct Current: Decodable {
    let date: Date
    let temperature : Double
    let feelsLike: Double
    let weather: [DailyWeather]
    let precipitation: Double?
    
    var temperatureInCelzius : String{"\(Int(temperature))°C"}
    var precipitationString : String{"\(round((precipitation ?? 0)*100))%"}
    var feelsLikeString : String{"Feels like\(Int(feelsLike))°C"}
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case weather
        case precipitation = "pop"
    }
}

// MARK: - Weather
struct DailyWeather: Decodable {
    let description : String
    let icon: String

    enum CodingKeys: String, CodingKey {
        case description = "main"
        case icon
    }
    
    
    var image: UIImage? {
    
    switch icon {
        case "03d":
            return UIImage(systemName: "cloud.fill")
        case "04d":
            return UIImage(systemName: "cloud.fill")
        case "11d":
            return UIImage(systemName: "cloud.bolt.fill")
        case "09d":
            return UIImage(systemName: "cloud.drizzle.fill")
        case "10d":
            return UIImage(systemName: "cloud.rain.fill")
        case "13d":
            return UIImage(systemName: "cloud.snow.fill")
        case "50d":
            return UIImage(systemName: "smoke.fill")
        case "01d":
            return UIImage(systemName: "sun.max.fill")
        case "02d":
            return UIImage(systemName: "cloud.sun.fill")
        default:
            return UIImage(systemName: "moon.circle.fill")
        }
    }
}


























// MARK: - Welcome
//
//
//struct WeatherResponse: Decodable {
//
//    let current: CurrentWeather
//    let hourly: [CurrentWeather]
//    
//    
//    enum Coding: String,CodingKey{
//        
//        case current
//        case hourly
//    }
//}
//
//// MARK: - Current
//struct CurrentWeather: Decodable {
//    let date: Date
//    let temperature : Double
//    let feelsLike: Double
//    let weather: [Weather]
//    let pop: Double?
//
//    var temperatureWithCelsius: String {"\(Int(temperature))°C"}
//    var fellsLikeWithCelsius: String {"Feels like\(Int(feelsLike))°C"}
//
//    var precipitation: String {"\(round((pop)!*100))%"}
//    
//    
//    
//    enum CodingKeys: String, CodingKey {
//        case date = "dt"
//        case temperature = "temp"
//        case feelsLike = "feels_like"
//        case weather
//        case pop
//        
//    }
//}
// 
//
//// MARK: - Weather
//struct Weather: Decodable {
//    
//    let description: String
//        let icon: String
//    
//    enum CodingKeys: String, CodingKey {
//        case description = "main"
//        case icon
//    }
//
//    
//    var image: UIImage? {
//        
//        switch icon {
//        case "03d":
//            return UIImage(systemName: "cloud.fill")
//        case "04d":
//            return UIImage(systemName: "cloud.fill")
//        case "11d":
//            return UIImage(systemName: "cloud.bolt.fill")
//        case "09d":
//            return UIImage(systemName: "cloud.drizzle.fill")
//        case "10d":
//            return UIImage(systemName: "cloud.rain.fill")
//        case "13d":
//            return UIImage(systemName: "cloud.snow.fill")
//        case "50d":
//            return UIImage(systemName: "smoke.fill")
//        case "01d":
//            return UIImage(systemName: "sun.max.fill")
//        case "02d":
//            return UIImage(systemName: "cloud.sun.fill")
//        default:
//            return UIImage(systemName: "moon.circle.fill")
//        }
//    }
//
//}
//
//// MARK: - FeelsLike
//struct Temperature: Decodable {
//    let day: Double
//    var temperatureWithCelsius: String {"\(Int(day))°C"}
//}
//
