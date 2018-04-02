//
//  WeatherData.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 3/29/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class WeatherData {
    static let iconBaseURL = "https://openweathermap.org/img/w/"
    
    var description: String!
    var temperature: Float!
    var iconImgURL: URL!
    
    init(dictionary: [String: Any]) {
        let weatherArr = dictionary["weather"] as! [Any]
        let weatherDict = weatherArr[0] as! [String: Any]
        let mainDataDict = dictionary["main"] as! [String: Any]
        description = weatherDict["description"] as? String ?? "No description available"
        temperature = mainDataDict["temp"] as? Float ?? 0.0
        
        let icon = weatherDict["icon"] as! String
        let iconImgURLString = WeatherData.iconBaseURL + icon + ".png"
        iconImgURL = URL(string: iconImgURLString)
        
    }
}
