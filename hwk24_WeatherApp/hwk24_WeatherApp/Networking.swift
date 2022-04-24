//
//  Networking.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 19.04.22.
//

import Foundation
import CoreLocation

class Networking {
    
    func requestCity(urlString: String, completion: @escaping ([City]?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
               
                let gottenInfo =  try decoder.decode([City].self, from: data)
                DispatchQueue.main.async {
                    completion(gottenInfo)
                }
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    
    func requestWeather(urlString: String, completion: @escaping (Weather) -> Void) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            
            guard let data = data else { return }
            
            do {
                let decoder = JSONDecoder()
               
                let gottenInfo =  try decoder.decode(Weather.self, from: data)
                DispatchQueue.main.async {
                    completion(gottenInfo)
                }
                
            } catch {
                print(error.localizedDescription)
            }
        }.resume()
        
    }
    

}

