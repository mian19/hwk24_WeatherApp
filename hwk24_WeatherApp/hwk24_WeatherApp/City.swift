//
//  City.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 13.04.22.
//

import Foundation

struct City: Codable, Equatable {
    let name: String
    let latitude: Double
    let longetude: Double
    let country: String
    let state: String?
}
