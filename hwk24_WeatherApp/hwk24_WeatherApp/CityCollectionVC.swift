//
//  CityCollectionView.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 18.04.22.
//

import UIKit
import CoreLocation

class CityCollectionVC: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    private let network = Networking()
    private let bar = UIToolbar()
    private let layout = UICollectionViewFlowLayout()
    private let myAPIKeyForCity = "7c6c27539d3385b12169493729304bbe"
    private let myAPIKeyForWeather = "a3096c5ad0644d94a1e73625221304"
    private let defaults = UserDefaults.standard
    private let locationManager = CLLocationManager()
    private var arrayOfWeatherForMyCities: [Weather]? = []
    private var arrayOfMyCities: [City]? {
        get {
            if let data = defaults.value(forKey: "MyCities") as? Data {
                return try! PropertyListDecoder().decode([City].self, from: data)
            } else {
                return []
            }
        }
        set {
            if let data = try? PropertyListEncoder().encode(newValue) {
                defaults.set(data, forKey: "MyCities")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        layout.scrollDirection = .horizontal
        
        collectionView.backgroundColor = .green
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        
        startLocationManager()
        startLoadingWeather()
        
        bar.frame = CGRect(x: 0, y: view.bounds.maxY - 50, width: view.bounds.width, height: 50)
        bar.backgroundColor = .red
        view.addSubview(bar)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfWeatherForMyCities?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 50)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        
        if let weather = arrayOfWeatherForMyCities?[indexPath.row] {
            cell.configure(inputWeather: weather)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    private func startLocationManager() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
        }
    }
    
    private func startLoadingWeather() {
        self.arrayOfMyCities?.forEach{
            let urlWeather = "https://api.weatherapi.com/v1/forecast.json?key=\(self.myAPIKeyForWeather)&q=\($0.latitude),\($0.longetude)&days=3&aqi=no&alerts=no"
            self.network.requestWeather(urlString: urlWeather, completion: { result in
                
                self.arrayOfWeatherForMyCities?.append(result)
                print(self.arrayOfWeatherForMyCities)
                DispatchQueue.main.async {
                    print(self.arrayOfWeatherForMyCities)
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    private func addCityToMyCities(city: City) {
        arrayOfMyCities?.append(City(name: city.name, latitude: city.latitude, longetude: city.longetude, country: city.country, state: city.state))
    }
    
}

extension CityCollectionVC: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            print(lastLocation.coordinate)
            let urlCity = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lastLocation.coordinate.latitude)&lon=\(lastLocation.coordinate.longitude)&limit=5&appid=\(myAPIKeyForCity)"
            network.requestCity(urlString: urlCity, completion: { result in
                
                if let city = result?.last{
                    if !(self.arrayOfMyCities?.contains(where: { city == $0 }) ?? false) {
                        self.addCityToMyCities(city: city)
                        
                    }
                    print(self.arrayOfMyCities)
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}