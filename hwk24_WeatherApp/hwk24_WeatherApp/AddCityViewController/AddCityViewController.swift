//
//  AddCityViewController.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 29.04.22.
//

import UIKit
import CoreLocation

class AddCityViewController: UIViewController {
    
    private let network = Networking()
    private var table = UITableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private let locationManager = CLLocationManager()
    private let myAPIKeyForCity = "7c6c27539d3385b12169493729304bbe"
    private let defaults = UserDefaults.standard
    private var arrayOfFoundedCities: [City]?
    var arrayOfMyCities: [City]? {
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
    
    override func loadView() {
        super.loadView()
        view.addSubview(table)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setSearchController()
        setGPSButton()
        
        table.delegate = self
        table.dataSource = self
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cityList")
        table.translatesAutoresizingMaskIntoConstraints = false
        
        setElements()
    }
    
    private func setSearchController() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.searchController = searchController
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationController?.navigationBar.prefersLargeTitles = true
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.title = "Add new city"
    }
    
    private func setGPSButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "location.viewfinder"), style: .done, target: self, action: #selector(findMyPlace))
    }
    
    private func setElements() {
        NSLayoutConstraint.activate([
            table.widthAnchor.constraint(equalTo: view.widthAnchor),
            table.heightAnchor.constraint(equalTo: view.heightAnchor),
            table.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            table.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc private func findMyPlace() {
        
        
        if (locationManager.authorizationStatus == .denied) || (locationManager.authorizationStatus == .notDetermined) {
            let alert = UIAlertController.enableGPS()
            self.present(alert, animated: true, completion: nil)
        } else {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
            locationManager.requestLocation()
        }
    }
    
    private func addCityToMyCities(city: City) {
        arrayOfMyCities?.append(City(name: city.name, latitude: city.latitude, longetude: city.longetude, country: city.country, state: city.state))
    }
}

extension AddCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        arrayOfFoundedCities?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = table.dequeueReusableCell(withIdentifier: "cityList", for: indexPath)
        var conf = cell.defaultContentConfiguration()
        
        if let city = arrayOfFoundedCities?[indexPath.row] {
            conf.text = "\(city.name)" + ", \(city.country)"
            conf.secondaryText = "\(city.state ?? "")"
        }
        
        cell.contentConfiguration = conf
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let city = arrayOfFoundedCities?[indexPath.row] {
            if !(self.arrayOfMyCities?.contains(where: { city == $0 }) ?? false) {
                self.addCityToMyCities(city: city)
                let alert = UIAlertController.cityNoExistAlert(city: city, prevPage: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                self.present(alert, animated: true, completion: nil)
                
            } else {
                let alert = UIAlertController.cityExistAlert(city: city)
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
}

extension AddCityViewController: UISearchBarDelegate {
    
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        let urlString = "https://api.openweathermap.org/geo/1.0/direct?q=\(searchText)&limit=5&appid=\(self.myAPIKeyForCity)"
        network.requestListCities(urlString: urlString, completion: {
            result in
            self.arrayOfFoundedCities = result
            DispatchQueue.main.async {
                self.table.reloadData()
            }
        })
    }
}

extension AddCityViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let lastLocation = locations.last {
            let urlString = "https://api.openweathermap.org/geo/1.0/reverse?lat=\(lastLocation.coordinate.latitude)&lon=\(lastLocation.coordinate.longitude)&limit=5&appid=\(myAPIKeyForCity)"
            network.requestCity(urlString: urlString, completion: { result in
                
                if let city = result?.last{
                    if !(self.arrayOfMyCities?.contains(where: { city == $0 }) ?? false) {
                        self.addCityToMyCities(city: city)
                        let alert = UIAlertController.cityNoExistAlert(city: city, prevPage: { _ in
                            self.navigationController?.popViewController(animated: true)
                        })
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        let alert = UIAlertController.cityExistAlert(city: city)
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            })
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
}
