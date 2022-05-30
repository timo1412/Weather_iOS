//
//  DailyResponse.swift
//  zadanieUI
//
//  Created by Timotej Čery on 25/05/2022.
//
import Foundation
import UIKit

// MARK: - Welcome
struct DailyResponse: Decodable {
    let daily: [Daily]

    enum CodingKeys: String, CodingKey {
        case daily
    }
}

// MARK: - Daily
struct Daily: Decodable {
    let date: Date
    let temperature: Temp
    let feelsLike: FeelsLike
    let weather: [Weather]
    let precipitation: Double
    
    var feelsLikeStrin:String{"Feels temp \(Int(feelsLike.day))°C"}
    var temperatureString:String{"Temp \(Int(temperature.day))°C"}
    var precipitationStrin: String{"Rain \(Int(precipitation))%"}
    
    enum CodingKeys: String, CodingKey {
        case date = "dt"
        case temperature = "temp"
        case feelsLike = "feels_like"
        case weather
        case precipitation = "pop"
    }
}

// MARK: - FeelsLike
struct FeelsLike: Decodable {
    let day: Double
}

// MARK: - Temp
struct Temp: Decodable {
    let day: Double
    
}

// MARK: - Weather
struct Weather: Decodable {
    let id: Int
    let main, weatherDescription, icon: String

    enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
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
