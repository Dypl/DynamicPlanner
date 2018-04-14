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

class MapWeatherViewController: UIViewController, LocationUpdateDelegate, UITextFieldDelegate, SearchResultDelegate {
    
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
    var polyline = GMSPolyline()

    @IBOutlet weak var point_a: UILabel!
    @IBOutlet weak var point_b: UILabel!

    @IBOutlet weak var origin: UILabel!
    @IBOutlet weak var destination: UILabel!

    
    @IBOutlet weak var endTextField: UITextField!
    @IBOutlet weak var startTextField: UITextField!
    //    @IBOutlet weak var tableView: UITableView!
    var currentLocation: CLLocation!
    let LocationManager = LocationSingleton.shared

    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizerForImage = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        let tapGestureRecognizerForLabel = UITapGestureRecognizer(target: self, action: #selector(self.refreshTapped(sender:)))
        refreshImageView.addGestureRecognizer(tapGestureRecognizerForImage)
        refreshLabel.addGestureRecognizer(tapGestureRecognizerForLabel)
        
        
        startTextField.addTarget(self, action: #selector(self.textFieldTapped(_:)), for: UIControlEvents.touchDown)
        endTextField.addTarget(self, action: #selector(self.textFieldTapped(_:)), for: UIControlEvents.touchDown)
        LocationManager.delegate = self
        LocationManager.startUpdatingUserLocation()
        

        let a_coordinate_string = "2.915142,101.657498"
        let b_coordinate_string = "2.909960,101.654674"

                let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(a_coordinate_string)&destinations=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
        

//        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
        // We need to handle API KEYS: IN APP DELEGATE & WITHIN THIS ENDPOINT.

        guard let url = URL(string: urlString) else {
            print("Error: cannot create URL")
            return
        }
        // TO DO: Create methods for functional decomposition:
        //Testing stage.
        let urlRequest = URLRequest(url: url)

        // set up the session
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        // make the request
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in

            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                //print(json)
                //This will be used with the matrixapi.
                
//                if let array = json["routes"] as? NSArray {
//                    print("hi")
//                    if let routes = array[0] as? NSDictionary{
//                        if let overview_polyline = routes["overview_polyline"] as? NSDictionary{
//                            if let points = overview_polyline["points"] as? String{
//                                // print(points)
//                                // Use DispatchQueue.main for main thread for handling UI
//                                DispatchQueue.main.async {
//                                    // show polyline
//                                    let path = GMSPath(fromEncodedPath:points)
////
////                                    self.polyline.path = path
////                                    self.polyline.strokeWidth = 4
////                                    self.polyline.strokeColor = UIColor.init(hue: 210, saturation: 88, brightness: 84, alpha: 1)
////                                    print(mapView, "Mapa")
////                                    self.polyline.map = mapView
//                                    //This will be used later in a different view controller.
//                                }
//                            }
//                        }
//                    }
//                }
              
                
                if let array = json["rows"] as? NSArray {
                    print("Yes we entered here")
                    if let rows = array[0] as? NSDictionary{
                        if let array2 = rows["elements"] as? NSArray{
                            if let elements = array2[0] as? NSDictionary{
                                if let duration = elements["duration"] as? NSDictionary {
                                    if let text = duration["text"] as? String{
                                        DispatchQueue.main.async {
                                            self.point_a.text = text;
                                        }
                                    }
                                }
              
                                if let duration = elements["distance"] as? NSDictionary {
                                    if let text = duration["text"] as? String{
                                        DispatchQueue.main.async {
                                            self.point_b.text = text;
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }

        })



        task.resume()


        
        

        
        
        
       
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
            //fetchWeatherData()
        }
    }
    
    func resetFieldsToDefaults() {
        self.weatherDescriptionLabel.text = "-----"
        self.temperatureLabel.text = "--"
        self.HiLoTempLabel.text = "-----"
        self.cityLabel.text = "-----"
    }
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    // Created : json error, used in try & catch.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    
    var isStartTextFieldTapped = false
    
    @objc func textFieldTapped(_ sender: UITextField) {
        
        isStartTextFieldTapped = sender == startTextField
        
        print("in here")
        let searchPopUpVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "SearchPopUpVC") as! SearchPopUpViewController
       searchPopUpVC.delegate = self
        self.addChildViewController(searchPopUpVC)
        searchPopUpVC.view.frame = self.view.frame
        self.view.addSubview(searchPopUpVC.view)
        searchPopUpVC.didMove(toParentViewController: self)
    }
    
    func searchResult(destination: String?) {
        if isStartTextFieldTapped {
            startTextField.text = destination
        } else {
            endTextField.text = destination
        }
    }

}

