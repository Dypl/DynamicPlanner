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
    var tempMax: Float!
    var tempMin: Float!
    var iconImgURL: URL!
    var city: String!
    
    init(dictionary: [String: Any]) {
        let weatherArr = dictionary["weather"] as! [Any]
        let weatherDict = weatherArr[0] as! [String: Any]
        let mainDataDict = dictionary["main"] as! [String: Any]
        description = weatherDict["description"] as? String ?? "No description available"
        temperature = mainDataDict["temp"] as? Float ?? 0.0
        tempMax = mainDataDict["temp_max"] as? Float ?? 0.0
        tempMin = mainDataDict["temp_min"] as? Float ?? 0.0
        
        let icon = weatherDict["icon"] as! String
        let iconImgURLString = WeatherData.iconBaseURL + icon + ".png"
        iconImgURL = URL(string: iconImgURLString)
        
        city = dictionary["name"] as! String
    }
}
