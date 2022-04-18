////
////  ViewController.swift
////  hwk24_WeatherApp
////
////  Created by Kyzu on 11.04.22.
////
//
//import UIKit
//import CoreLocation
//
//class ViewController: UIViewController {
//    let myAPIKeyForCity = "7c6c27539d3385b12169493729304bbe"
//    let myAPIKeyForWeather = "a3096c5ad0644d94a1e73625221304"
//    let locationManager = CLLocationManager()
//    let defaults = UserDefaults.standard
//    
////    var arrayOfMyCities: [City] {
////         get {
////             if let data = defaults.value(forKey: "MyCities") as? Data {
////                 return try! PropertyListDecoder().decode([City].self, from: data)
////             } else {
////                 return []
////             }
////         }
////
////         set {
////             if let data = try? PropertyListEncoder().encode(newValue) {
////                 defaults.set(data, forKey: "MyCities")
////             }
////         }
////     }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        startLocationManager()
//    }
//    
//    
//    private func startLocationManager() {
//        locationManager.requestWhenInUseAuthorization()
//        
//        if CLLocationManager.locationServicesEnabled() {
//           
//            locationManager.delegate = self
//            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
//            locationManager.requestLocation()
//            
//            
//        }
//    }
//    
//    private func addCityToMyCities(city: City) {
//        arrayOfMyCities.append(City(name: city.name, latitude: city.latitude, longetude: city.longetude, country: city.country, state: city.state, weather: nil))
//    }
//    
//    private func networking<T>(cityInfo: T) {
//        var urlString = ""
//        var tag: Int!
//        var infoForRequest: Any!
//        if let city = cityInfo as? City {
//            tag = 1
//            infoForRequest = city
//            urlString = "https://api.weatherapi.com/v1/forecast.json?key=\(myAPIKeyForWeather)&q=\(city.latitude),\(city.longetude)&days=3&aqi=no&alerts=no"
//        }
//        
//        if let city = cityInfo as? String {
//            tag = 2
//            infoForRequest = city
//            urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(city)&limit=5&appid=\(myAPIKeyForCity)"
//        }
//        
//        if let city = cityInfo as? CLLocationCoordinate2D {
//            tag = 3
//            infoForRequest = city
//            urlString =  "https://api.openweathermap.org/geo/1.0/reverse?lat=\(city.latitude)&lon=\(city.longitude)&limit=5&appid=\(myAPIKeyForCity)"
//        }
//        
//        guard let url = URL(string: urlString) else { return }
//        
//        URLSession.shared.dataTask(with: url) {data, response, error in
//            
//            if let error = error {
//                print (error.localizedDescription)
//            }
//            guard let data = data else { return }
//            
//                switch tag {
//                case 1:
//                    self.getWeather(city: infoForRequest as! City, data: data, error: error)
//                case 2:
//                    self.getCityInfoByCityName(cityName: infoForRequest as! String, data: data, error: error)
//                case 3:
//                    self.getCityInfoByCoordinates(coordinates: infoForRequest as! CLLocationCoordinate2D, data: data, error: error)
//                default:
//                    break
//                }
//            
//        }.resume()
//    }
//    
//    fileprivate func getWeather(city: City, data: Data, error: Error?) {
//        
//        do {
//            let decoder = JSONDecoder()
//            let gettingWeather = try decoder.decode(Weather.self, from: data)
//            print (gettingWeather)
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//    fileprivate func getCityInfoByCityName(cityName: String, data: Data, error: Error?) {
//            
//            do {
//                let decoder = JSONDecoder()
//                let gettingCities = try decoder.decode([City].self, from: data)
//                print (gettingCities)
//            } catch {
//                print(error.localizedDescription)
//            }
//    }
//    
//    fileprivate func getCityInfoByCoordinates(coordinates: CLLocationCoordinate2D, data: Data, error: Error?) {
//        
//        do {
//            let decoder = JSONDecoder()
//            let gettedCities = try decoder.decode([City].self, from: data)
//            if let city = gettedCities.last {
//                if arrayOfMyCities.isEmpty || arrayOfMyCities.contains(where: { city == $0 }) {
//                   addCityToMyCities(city: city)
//                }
//            }
//            print("It's my CITIES:\n")
//            print(arrayOfMyCities)
//            print("-------------\n\n\n\n")
//        } catch {
//            print(error.localizedDescription)
//        }
//    }
//    
//   
//}
//
//extension ViewController: CLLocationManagerDelegate {
//   
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let lastLocation = locations.last {
//            print(lastLocation)
//            networking(cityInfo: lastLocation.coordinate)
//            
//        }
//    }
//    
//    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
//            print("Failed to find user's location: \(error.localizedDescription)")
//        }
//    
//
//}
