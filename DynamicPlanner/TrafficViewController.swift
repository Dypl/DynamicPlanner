//
//  TrafficViewController.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 4/12/18.
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


class TrafficViewController: UIViewController {
    
     var polyline = GMSPolyline()
    
    @IBOutlet weak var back: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       

//         Do any additional setup after loading the view.
//
//                 Create a GMSCameraPosition that tells the map to display the
//                 coordinate 2.909960,101.654674 at zoom level 16.
                let camera = GMSCameraPosition.camera(withLatitude: 2.909960, longitude:101.654674, zoom: 16.0)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                mapView.isMyLocationEnabled = true
                view = mapView

                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: 2.909960, longitude: 101.654674)
                marker.title = "Cyberjaya"
                marker.snippet = "Malaysia"
                marker.map = mapView

                let marker2 = GMSMarker()
                marker2.position = CLLocationCoordinate2D(latitude: 2.915142, longitude: 101.657498)
                marker2.title = "MSC"
                marker2.snippet = "Malaysia"
                marker2.map = mapView
                // TO DO: Remove statically created co-ordinates
        
              view.addSubview(back)


        let a_coordinate_string = "2.915142,101.657498"
        let b_coordinate_string = "2.909960,101.654674"

//        let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(a_coordinate_string)&destinations=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
//

                let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
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
                print(json)
               // This will be used with the matrixapi.

                                if let array = json["routes"] as? NSArray {
                                    print("hi")
                                    if let routes = array[0] as? NSDictionary{
                                        if let overview_polyline = routes["overview_polyline"] as? NSDictionary{
                                            if let points = overview_polyline["points"] as? String{
                                                // print(points)
                                                // Use DispatchQueue.main for main thread for handling UI
                                                DispatchQueue.main.async {
                                                    // show polyline
                                                    let path = GMSPath(fromEncodedPath:points)

                                                    self.polyline.path = path
                                                    self.polyline.strokeWidth = 4
                                                    self.polyline.strokeColor = UIColor.init(hue: 210, saturation: 88, brightness: 84, alpha: 1)
                                                    print(mapView, "Mapa")
                                                    self.polyline.map = mapView

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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
