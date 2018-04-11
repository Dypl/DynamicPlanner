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

    @IBOutlet weak var HiLoTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshImageView: UIImageView!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var curDate: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.locationManager.requestAlwaysAuthorization()
        let tapGestureRecognizerForImage = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        let tapGestureRecognizerForLabel = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        refreshImageView.addGestureRecognizer(tapGestureRecognizerForImage)
        refreshLabel.addGestureRecognizer(tapGestureRecognizerForLabel)
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        } else {
            // location not accessible
            self.displayAlert(title: "Location Error", errorMsg: "Location not enabled")
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
            if let error = error {
                self.displayAlert(title: "Error", errorMsg: error.localizedDescription)
            } else {
                self.weatherData = weatherData
                print(weatherData!.description)
                print(weatherData!.temperature)
                
                DispatchQueue.main.async() {
                    self.setWeatherData()
                    self.isFetchingWeather = false
                }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[0]
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        if !isFetchingWeather {
            fetchWeatherData()
        }
    }
    
    func setWeatherData() {
        if let weatherData = self.weatherData {
            self.cityLabel.text = weatherData.city
            let date = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM-dd-yyyy"
            let result = dateFormatter.string(from: date)
            self.curDate.text = result
            
            self.weatherDescriptionLabel.text = weatherData.description
            if let temp = weatherData.temperature {
                let tempStr = String(Int(temp)) + " " + "\u{00B0}"
                self.temperatureLabel.text = tempStr
            }
            let tempMax = weatherData.tempMax
            let tempMin = weatherData.tempMin
            let hiLoTempStr = String(Int(tempMax!)) + " \u{00B0} / " + String(Int(tempMin!)) + " \u{00B0}"
            self.HiLoTempLabel.text = hiLoTempStr
            if let iconImgURL = weatherData.iconImgURL {
                self.weatherIconImg.af_setImage(withURL: iconImgURL, placeholderImage: nil, filter: nil, progress: nil, progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: { (response) in
                    
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
    }
    
    func displayAlert(title: String, errorMsg: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func refreshTapped(sender: UITapGestureRecognizer) {
        if !isFetchingWeather {
            resetFieldsToDefaults()
            fetchWeatherData()
        }
    }
    
    func resetFieldsToDefaults() {
        self.weatherDescriptionLabel.text = "-----"
        self.temperatureLabel.text = "--"
        self.HiLoTempLabel.text = "-----"
        self.cityLabel.text = "-----"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
