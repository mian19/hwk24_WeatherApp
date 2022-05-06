//
//  UIAlertController+customAlert.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 3.05.22.
//

import UIKit

extension UIAlertController {
    
    static func cityExistAlert(city: City) -> UIAlertController {
        let alert = UIAlertController(title: "Result", message: "\(city.name), \(city.country)\n alredy in your cities", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
    }
    
    static func cityNoExistAlert(city: City, prevPage: @escaping (UIAlertAction)->()) -> UIAlertController {
        let alert = UIAlertController(title: "Result", message: "\(city.name), \(city.country)\n was added to your cities", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default, handler: prevPage)
        alert.addAction(okButton)
        return alert
        
    }
    
    static func enableGPS() -> UIAlertController {
        let alert = UIAlertController(title: "Warning", message: "Enable app your location!", preferredStyle: .alert)
        let okButton = UIAlertAction(title: "ok", style: .default, handler: nil)
        alert.addAction(okButton)
        return alert
        
    }
    
    
}
