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
    private var bar: UIToolbar!
    private let layout = UICollectionViewFlowLayout()
    private let myAPIKeyForCity = "7c6c27539d3385b12169493729304bbe"
    private let myAPIKeyForWeather = "a3096c5ad0644d94a1e73625221304"
    private let defaults = UserDefaults.standard
    private let locationManager = CLLocationManager()
    private var arrayOfWeatherForMyCities: [Weather]? = []
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(willEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        navigationController?.isNavigationBarHidden = true
        layout.scrollDirection = .horizontal
        
        collectionView.register(CityCollectionViewCell.self, forCellWithReuseIdentifier: CityCollectionViewCell.identifier)
        collectionView.collectionViewLayout = layout
        collectionView.isPagingEnabled = true
        
        bar = UIToolbar(frame: CGRect(x: 0, y: view.bounds.maxY - 50, width: view.bounds.width, height: 50))
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let myCitiesButton = UIBarButtonItem(image: UIImage(systemName: "list.dash"), style: .done, target: self, action: #selector(goToMyCities))
        bar.items = [flexibleSpace, myCitiesButton]
        bar.sizeToFit()
        view.addSubview(bar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
   
            
        
        if arrayOfMyCities?.count == 0 {
            goToMyCities()
            
        }
        
        arrayOfWeatherForMyCities = []
        
        locationManager.requestWhenInUseAuthorization()

        startLoadingWeather()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    @objc func willEnterForeground() {
        print("willEnterForeground")
        arrayOfWeatherForMyCities = []
        startLoadingWeather()
    }
    
    @objc func goToMyCities() {
        let storyboard = UIStoryboard(name: "TableOfCitiesViewController", bundle: Bundle.main)
        let viewController = storyboard.instantiateInitialViewController() as! TableOfCitiesViewController
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrayOfWeatherForMyCities?.count ?? 1
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.bounds.width, height: view.bounds.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CityCollectionViewCell.identifier, for: indexPath) as! CityCollectionViewCell
        
        if let weather = arrayOfWeatherForMyCities?[indexPath.row] {
            cell.configure(inputWeather: weather)
            cell.reloadInputViews()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    private func startLoadingWeather() {
        
        self.arrayOfMyCities?.forEach{
            let urlWeather = "https://api.weatherapi.com/v1/forecast.json?key=\(self.myAPIKeyForWeather)&q=\($0.name)&days=3&aqi=no&alerts=no"
            self.network.requestWeather(urlString: urlWeather, completion: { result in
                DispatchQueue.main.async {
                    
                    self.arrayOfWeatherForMyCities?.append(result)
                    
                    self.collectionView.reloadData()
                }
            })
        }
    }
    
    
}
