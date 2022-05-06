//
//  ModelForJSON.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 12.04.22.
//

import Foundation


struct CityJSON: Decodable {
    let name: String
    let latitude: Double
    let longetude: Double
    let country: String
    let state: String?
    let weather: Weather?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longetude = "lon"
        case country
        case state
        case weather
    }
}

struct Weather: Decodable {
    let current: Current
    let forecast: Forecast
}

struct Current: Decodable {
    let temp_c: Double
    let humidity: Double
    let wind_kph: Double
    let condition: Condition
}

struct Condition: Decodable {
    let icon: String
}

struct Forecast: Decodable {
    let forecastday: [Forecastday]
}

struct Forecastday: Decodable {
    let day: Day
}

struct Day: Decodable {
    let mintemp_c: Double
    let maxtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let condition: Condition
}

