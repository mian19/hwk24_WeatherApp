//
//  UIToolbar+customBar.swift
//  hwk24_WeatherApp
//
//  Created by Kyzu on 25.04.22.
//

import Foundation
import UIKit
//list.dash
extension UIToolbar {
    
    static func customBar(frame: CGRect) -> UIToolbar {
        let bar = UIToolbar.init(frame: frame)
        var button = UIButton()
        button.imageView?.image = UIImage(systemName: "list.dash")
        bar.addSubview(button)
        
        button.frame = CGRect(x: bar.bounds.maxX - 60, y: 10, width: 50, height: 50)
       // setElements()
        return bar
    }
    
//    private func setElements() {
//        NSLayoutConstraint.activate([
//
//            butto
//
//        ])
//    }
}
