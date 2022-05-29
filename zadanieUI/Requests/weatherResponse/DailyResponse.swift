//
//  DailyResponse.swift
//  zadanieUI
//
//  Created by Timotej Čery on 25/05/2022.
//
import Foundation

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
    
    var feelsLikeStrin:String{"\(Int(feelsLike.day))°C"}
    var temperatureString:String{"\(Int(temperature.day))°C"}
    var precipitationStrin: String{"\(Int(precipitation))%"}
    
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
}
