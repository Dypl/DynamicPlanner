//
//  MapWeatherViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit

class MapWeatherViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWeatherData()
    }
    
    func fetchWeatherData() {
        WeatherApiManager().currentWeather(lat: 36.0, lon: 139.0) { (weatherData: WeatherData?, error: Error?) in
            print(weatherData!.description)
            print(weatherData!.temperature)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
