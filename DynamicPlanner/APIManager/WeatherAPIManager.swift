//
//  WeatherAPIManager.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 3/29/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class WeatherApiManager {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = valueForAPIKey(named: "OPEN_WEATHER_MAP_API_KEY")
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func currentWeather(lat: Double, lon: Double, completion: @escaping (WeatherData?, Error?) -> ()) {
        let url = URL(string: WeatherApiManager.baseUrl + "weather?appid=\(WeatherApiManager.apiKey)" + "&lat=\(lat)" + "&lon=\(lon)" + "&units=imperial")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let weatherData = WeatherData(dictionary: dataDictionary)
                completion(weatherData, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
}
