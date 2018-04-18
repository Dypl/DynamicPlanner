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
import AFNetworking
import SwiftyJSON
import GoogleMaps
import GooglePlaces
import Foundation
import BEMCheckBox

class MapWeatherViewController: UIViewController, LocationUpdateDelegate, UITextFieldDelegate, SearchResultDelegate {
    
    var weatherData: WeatherData?
    var gdata : GoogleDistanceData?
    
    var isFetchingWeather = false
    var isStartTextFieldTapped = false

    @IBOutlet weak var HiLoTempLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var refreshLabel: UILabel!
    @IBOutlet weak var refreshImageView: UIImageView!
    @IBOutlet weak var weatherIconImg: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var curDate: UILabel!
    @IBOutlet weak var point_a: UILabel!
    @IBOutlet weak var point_b: UILabel!
    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    
    var lat: Double?
    var lon: Double?
    var start_lon: Double?
    var start_lat: Double?
    var end_lon: Double?
    var end_lat: Double?
    
    var coord_a = ""
    var coord_b = ""
    
    var currentLocation: CLLocation!
    let LocationManager = LocationSingleton.shared
    
    var polyline = GMSPolyline()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizerForImage = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        let tapGestureRecognizerForLabel = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        refreshImageView.addGestureRecognizer(tapGestureRecognizerForImage)
        refreshLabel.addGestureRecognizer(tapGestureRecognizerForLabel)
        
        startTextField.addTarget(self, action: #selector(self.textFieldTapped(_:)), for: UIControlEvents.touchDown)
        endTextField.addTarget(self, action: #selector(self.textFieldTapped(_:)), for: UIControlEvents.touchDown)
        
        if LocationManager.isLocationServicesEnabled() {
            LocationManager.delegate = self
            LocationManager.startUpdatingUserLocation()
        }
    }
    
    func fetchWeatherData() {
        print("in fetchweatherData")
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
    
    func locationDidUpdateToLocation(location: CLLocation) {
        currentLocation = location
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
        print("Lat: \(self.currentLocation.coordinate.latitude)")
        print("Lon: \(self.currentLocation.coordinate.longitude)")
       
        fetchWeatherData()
        LocationManager.stopUpdatingUserLocation()
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
            LocationManager.startUpdatingUserLocation()
        }
    }
    
    func resetFieldsToDefaults() {
        self.weatherDescriptionLabel.text = "-----"
        self.temperatureLabel.text = "--"
        self.HiLoTempLabel.text = "-----"
        self.cityLabel.text = "-----"
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    @objc func textFieldTapped(_ sender: UITextField) {
        isStartTextFieldTapped = sender == startTextField
        let searchPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchPopUpVC") as! SearchPopUpViewController
       searchPopUpVC.delegate = self
        self.addChildViewController(searchPopUpVC)
        searchPopUpVC.view.frame = self.view.frame
        self.view.addSubview(searchPopUpVC.view)
        searchPopUpVC.didMove(toParentViewController: self)
    }
    
    func searchResult(destination: String?, lat: String?, lon: String?) {
        if isStartTextFieldTapped {
            startTextField.text = destination
            
            // To do: finx edge cases
            coord_a = String("\(lat!),\(lon!)")
            start_lat = Double(lat!)
            start_lon = Double(lon!)
            
            
            
            
        } else {
            endTextField.text = destination
            
            // To do: finx edge cases
           coord_b = String("\(lat!),\(lon!)")
            
            end_lat = Double(lat!)
            end_lon = Double(lon!)
            
        }
    }
    @IBAction func findRoute(_ sender: Any) {
        if(coord_a == "" || coord_b == "") {
            print("There is an error with retrieving route off coordinates.")
        } else {
            GoogleApiManager().searchDirectionsAPI(lat: coord_a, lon: coord_b) { (googleData: GoogleDistanceData?, error: Error?) in
                if let error = error {
                    self.displayAlert(title: "Error", errorMsg: error.localizedDescription)
                } else {
                    self.gdata = googleData
                    // print(self.gdata!)
                    //print(googleData!.distance)
                    DispatchQueue.main.async() {
                        self.point_a.text = googleData!.distance
                        self.point_b.text = googleData!.duration_eta
                    }
                }
            }
        }
    }
    
    @IBAction func didTapCheckBox(_ sender: BEMCheckBox) {
        // if checkbox is checkmarked
        if sender.on {
            if LocationManager.isLocationServicesEnabled() {
                start_lat = lat!
                start_lon = lon!
                coord_a = String("\(lat!),\(lon!)")
                startTextField.text = "Current Location"
                startTextField.isUserInteractionEnabled = false
            }
        } else {
            start_lat = nil
            start_lon = nil
            coord_a = ""
            startTextField.text = ""
            startTextField.isUserInteractionEnabled = true
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TrafficViewController {
            let vc = segue.destination as? TrafficViewController
            vc?.point_a = coord_a
            vc?.point_b = coord_b
            vc?.start_lat = start_lat!
            vc?.start_lon = start_lon!
            vc?.end_lat = end_lat!
            vc?.end_lon = end_lon!
            vc?.start_title =  startTextField.text
            vc?.end_title = endTextField.text
            vc?.dis = self.point_a.text
            vc?.dur = self.point_b.text
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
