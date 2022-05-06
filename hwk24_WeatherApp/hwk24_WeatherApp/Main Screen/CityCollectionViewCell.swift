//
//  CityCollectionViewCell.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 23.04.22.
//

import UIKit

class CityCollectionViewCell: UICollectionViewCell {
    static let identifier = "cityID"
    var cityNameLabel = UILabel()
    var currentTempLabel = UILabel()
    var currentImage = UIImageView()
    var humidityLabel = UILabel()
    var windLabel = UILabel()
    var forecastTable = UITableView()
    var currentWeather: Weather!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(inputWeather: Weather) {
        
        currentWeather = inputWeather
        let elements = [cityNameLabel, currentTempLabel, currentImage, humidityLabel, windLabel, forecastTable]
        cityNameLabel.text = inputWeather.location.name
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 40)
        
        currentTempLabel.text = "\(inputWeather.current.temp_c)°"
        currentTempLabel.font = UIFont.systemFont(ofSize: 80)
        currentImage.image = {(imageName: String) -> UIImage in
            let imageFromAssets = imageName.split(separator: "/").suffix(2).joined(separator: "/")
            return UIImage(named: imageFromAssets)!
        }(inputWeather.current.condition.icon)
        currentImage.contentMode = .scaleAspectFill
        
        humidityLabel.text = "hum. \(inputWeather.current.humidity) %"
        humidityLabel.font = UIFont.systemFont(ofSize: 30)
        
        windLabel.text = "wind \(inputWeather.current.wind_kph) kph"
        windLabel.font = UIFont.systemFont(ofSize: 30)
        
        forecastTable.dataSource = self
        forecastTable.delegate = self
        forecastTable.backgroundColor = UIColor(white: 1, alpha: 0.5)
        forecastTable.layer.cornerRadius = 20
        forecastTable.clipsToBounds = true
        forecastTable.isUserInteractionEnabled = false
        
        elements.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            if $0.isKind(of: UILabel.self) {
                let label =  $0 as! UILabel
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = .center
                label.textColor = .white
            }
            addSubview($0)
        }
        
        backgroundColor = inputWeather.current.is_day == 1 ?  UIColor(red: 0, green: 0.5373, blue: 0.8275, alpha: 1.0) : UIColor(red: 0.098, green: 0.0275, blue: 0, alpha: 1.0)
        forecastTable.reloadData()
        setElements()
    }
    
    private func setElements() {
        
        NSLayoutConstraint.activate([
            
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0.15 * self.bounds.height),
            cityNameLabel.widthAnchor.constraint(equalToConstant: 200),
            
            currentTempLabel.topAnchor.constraint(equalTo: cityNameLabel.bottomAnchor, constant: 20),
            currentTempLabel.trailingAnchor.constraint(equalTo: cityNameLabel.centerXAnchor, constant: 5),
            currentTempLabel.widthAnchor.constraint(equalToConstant: 140),
            
            currentImage.topAnchor.constraint(equalTo: currentTempLabel.topAnchor),
            currentImage.leadingAnchor.constraint(equalTo: cityNameLabel.centerXAnchor, constant: 5),
            currentImage.widthAnchor.constraint(equalToConstant: 100),
            currentImage.heightAnchor.constraint(equalToConstant: 100),
            
            humidityLabel.widthAnchor.constraint(equalTo: cityNameLabel.widthAnchor),
            humidityLabel.topAnchor.constraint(equalTo: currentTempLabel.bottomAnchor, constant: 20),
            humidityLabel.centerXAnchor.constraint(equalTo: cityNameLabel.centerXAnchor),
            
            windLabel.widthAnchor.constraint(equalTo: humidityLabel.widthAnchor),
            windLabel.topAnchor.constraint(equalTo: humidityLabel.bottomAnchor, constant: 20),
            windLabel.centerXAnchor.constraint(equalTo: humidityLabel.centerXAnchor),
            
            forecastTable.widthAnchor.constraint(equalTo: widthAnchor),
            forecastTable.topAnchor.constraint(equalTo: windLabel.bottomAnchor, constant: 20),
            forecastTable.heightAnchor.constraint(equalToConstant: 210)
            
        ])
    }
}

extension CityCollectionViewCell: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        currentWeather.forecast.forecastday.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = ForecastTableViewCell()
        cell.configure(inputWeather: currentWeather, day: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        tableView.bounds.height / CGFloat(currentWeather.forecast.forecastday.count)
    }
    
    
}
