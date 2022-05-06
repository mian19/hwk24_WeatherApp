//
//  ForecastTableViewCell.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 25.04.22.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    var dayLabel = UILabel()
    var icoView = UIImageView()
    var maxLabel = UILabel()
    var minLabel = UILabel()
    var currentWeather: Weather!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor(white: 1, alpha: 0.1)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(inputWeather: Weather, day: Int) {
        selectionStyle = .none
        let elements = [dayLabel, icoView, maxLabel, minLabel]
        dayLabel.text = getDayFromDate(dateString: inputWeather.forecast.forecastday[day].date)
        
        icoView.image = {(imageName: String) -> UIImage in
            let imageFromAssets = imageName.split(separator: "/").suffix(2).joined(separator: "/")
            return UIImage(named: imageFromAssets)!
        }(inputWeather.forecast.forecastday[day].day.condition.icon)
        
        maxLabel.text = String(inputWeather.forecast.forecastday[day].day.maxtemp_c)
        minLabel.text = String(inputWeather.forecast.forecastday[day].day.mintemp_c)
        
        elements.forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
            if $0.isKind(of: UILabel.self) {
                let label =  $0 as! UILabel
                label.adjustsFontSizeToFitWidth = true
                label.textAlignment = .left
                label.textColor = .white
                label.font = UIFont.systemFont(ofSize: 25)
            }
            addSubview($0)
        }
        
        minLabel.textColor = UIColor(white: 1, alpha: 0.7)
        
        setElements()
    }
    
    private func getDayFromDate(dateString: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let date = formatter.date(from: dateString) else {
            return ""
        }
        formatter.dateFormat = "EEEE"
        let dayInWeek = formatter.string(from: date)
        return dayInWeek
    }
    
    private func setElements() {
        
        NSLayoutConstraint.activate([
            
            dayLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            dayLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 5),
            dayLabel.widthAnchor.constraint(equalToConstant: bounds.width * 0.4),
            
            icoView.centerYAnchor.constraint(equalTo: centerYAnchor),
            icoView.leadingAnchor.constraint(equalTo: dayLabel.trailingAnchor, constant: 5),
            icoView.widthAnchor.constraint(equalToConstant: bounds.width * 0.2),
            
            maxLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            maxLabel.leadingAnchor.constraint(equalTo: icoView.trailingAnchor, constant: bounds.width * 0.2),
            maxLabel.widthAnchor.constraint(equalToConstant: bounds.width * 0.15),
            
            minLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            minLabel.leadingAnchor.constraint(equalTo: maxLabel.trailingAnchor, constant: 10),
            minLabel.widthAnchor.constraint(equalToConstant: bounds.width * 0.15)
            
        ])
    }
    
    
}
