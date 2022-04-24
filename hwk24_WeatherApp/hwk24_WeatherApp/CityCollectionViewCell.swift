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
   // var forecastTable: UITableView!
    
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(inputWeather: Weather) {
        var elements = [cityNameLabel, currentTempLabel, currentImage, humidityLabel, windLabel]
        cityNameLabel.text = inputWeather.location.name
        cityNameLabel.font = UIFont.boldSystemFont(ofSize: 30)
        currentTempLabel.text = "\(inputWeather.current.temp_c)°"
        currentTempLabel.font = UIFont.systemFont(ofSize: 25)
        currentImage.image = {(imageName: String) -> UIImage in
            let imageFromAssets = imageName.split(separator: "/").suffix(2).joined(separator: "/")
            return UIImage(named: imageFromAssets)!
        }(inputWeather.current.condition.icon)
        humidityLabel.text = "hum. \(inputWeather.current.humidity) %"
        windLabel.text = "wind \(inputWeather.current.wind_kph) kph"
        
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
        
       setElements()
    }
    
    private func setElements() {
        
        NSLayoutConstraint.activate([
        
            cityNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            cityNameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 20),
            cityNameLabel.widthAnchor.constraint(equalToConstant: 200),
            
        
        ])

    }
    

    
}
