//
//  ModelForJSON.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 12.04.22.
//

import Foundation


struct City: Codable, Equatable {
    let name: String
    let latitude: Double
    let longetude: Double
    let country: String
    let state: String?
    
    enum CodingKeys: String, CodingKey {
        case name
        case latitude = "lat"
        case longetude = "lon"
        case country
        case state
    }
}

struct Weather: Codable, Equatable {
    let location: Location
    let current: Current
    let forecast: Forecast
}

struct Location: Codable, Equatable {
    let name, region, country: String

}

struct Current: Codable, Equatable {
    let temp_c: Double
    let humidity: Double
    let wind_kph: Double
    let is_day: Int
    let condition: Condition
}

struct Condition: Codable, Equatable {
    let icon: String
}

struct Forecast: Codable, Equatable {
    let forecastday: [Forecastday]
}

struct Forecastday: Codable, Equatable {
    let day: Day
}

struct Day: Codable, Equatable {
    let mintemp_c: Double
    let maxtemp_c: Double
    let maxwind_kph: Double
    let avghumidity: Double
    let condition: Condition
}

