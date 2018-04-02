//
//  MapWeatherViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 3/25/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import CoreLocation
import AlamofireImage

class MapWeatherViewController: UIViewController, CLLocationManagerDelegate {
    
    let locationManager = CLLocationManager()
    
    var weatherData: WeatherData?
    var lat: Double?
    var lon: Double?
    var isFetchingWeather = false

    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var curDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // location not accessible
            print("Location not enabled")
            self.displayAlert(errorMsg: "Location not enabled")
        }
    }
    
    func fetchWeatherData() {
        if lat == nil || lon == nil {
            return
        }
        isFetchingWeather = true
        if !self.activityIndicator.isAnimating {
            self.activityIndicator.startAnimating()
        }
        WeatherApiManager().currentWeather(lat: lat!, lon: lon!) { (weatherData: WeatherData?, error: Error?) in
            self.weatherData = weatherData
            print(weatherData!.description)
            print(weatherData!.temperature)
            self.isFetchingWeather = false
            DispatchQueue.main.async() {
                self.setWeatherData()
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        print(locations)
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        if !isFetchingWeather {
            fetchWeatherData()
        }
    }
    
    func setWeatherData() {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM-dd-yyyy"
        let result = dateFormatter.string(from: date)
        self.curDate.text = result
        
        self.weatherDescriptionLabel.text = weatherData?.description
        if let temp = weatherData!.temperature {
            let tempStr = String(temp) + " " + "\u{00B0}"
            self.temperatureLabel.text = tempStr
        }
        
        if let iconImgURL = weatherData?.iconImgURL {
            weatherIconImg.af_setImage(withURL: iconImgURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (response) in
                if response.result.value != nil {
                    // set default img
                } else {
                    print(response.result.error?.localizedDescription ?? "error")
                }
                
                DispatchQueue.main.async {
                    if self.activityIndicator.isAnimating {
                        self.activityIndicator.stopAnimating()
                    }
                }
            })
        }
    }
    
    func displayAlert(errorMsg: String) {
        // create the alert
        let alert = UIAlertController(title: "Login Failed", message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
