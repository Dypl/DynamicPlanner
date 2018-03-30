//
//  WeatherData.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 3/29/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class WeatherData {
    var description: String!
    var temperature: String!
    
    
    init(dictionary: [String: Any]) {
        let weatherArr = dictionary["weather"] as! [Any]
        let weatherDict = weatherArr[0] as! [String: Any]
        let mainDataDict = dictionary["main"] as! [String: Any]
        description = weatherDict["description"] as? String ?? "No description available"
        temperature = mainDataDict["temp"] as? String ?? "N/A"
    }
}
