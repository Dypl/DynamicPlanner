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
    var gdata : GoogleMatrixData?
    
    @IBOutlet weak var back: UIButton!
    
    var point_a = ""
    var point_b = ""
    var start_lat: Double!
    var start_lon: Double!
    var end_lat : Double!
    var end_lon : Double!
    

    override func viewDidLoad() {
        super.viewDidLoad()
       

//         Do any additional setup after loading the view.
//
//                 Create a GMSCameraPosition that tells the map to display the
//                 coordinate 2.909960,101.654674 at zoom level 16.
//        let vancouver = CLLocationCoordinate2D(latitude: 49.26, longitude: -123.11)
//        let calgary = CLLocationCoordinate2D(latitude: 51.05,longitude: -114.05)
//        let bounds = GMSCoordinateBounds(coordinate: vancouver, coordinate: calgary)
//        let camera = mapView.camera(for: bounds, insets: UIEdgeInsets())!
//        mapView.camera = camera
        
        
                let camera = GMSCameraPosition.camera(withLatitude: start_lat, longitude:start_lon, zoom: 2)
                let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
                mapView.isMyLocationEnabled = true
                view = mapView

                // Creates a marker in the center of the map.
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: start_lat, longitude: start_lon)
                //marker.title = "Cyberjaya"
                //marker.snippet = "Malaysia"
                marker.map = mapView

                let marker2 = GMSMarker()
                marker2.position = CLLocationCoordinate2D(latitude: end_lat, longitude: end_lon)
               // marker2.title = "MSC"
                //marker2.snippet = "Malaysia"
                marker2.map = mapView
                // TO DO: Remove statically created co-ordinates
        
                let location_1 = CLLocationCoordinate2D(latitude: start_lat , longitude: start_lon)
                let location_2 = CLLocationCoordinate2D(latitude: end_lat,longitude: end_lon)
                let bounds = GMSCoordinateBounds(coordinate: location_1, coordinate: location_2)
//                let cameraz = mapView.camera(for: bounds, insets: UIEdgeInsets())!
//                 mapView.camera = cameraz
        
                let update = GMSCameraUpdate.fit(bounds, withPadding: 50.0)
                mapView.moveCamera(update)
////
//                mapView.animate(toLocation: CLLocationCoordinate2D(latitude: start_lat, longitude: start_lon))
        
              view.addSubview(back)
print("********************")
print(point_a)
print(point_b)
        print("********************")
        
        let a = point_a//"36.439024,-121.327514"
        let b = point_b//"36.4426161,-121.3180448"
        
        
        GoogleApiManager().searchDistanceMatrixAPI(lat:a, lon:b) { (googleData: GoogleMatrixData?, error: Error?) in
            if let error = error {
                self.displayAlert(title: "Error", errorMsg: error.localizedDescription)
            } else {
                
                self.gdata = googleData
                // print(self.gdata!)
                //print(googleData!.distance)
                //print(gdata!.)
                DispatchQueue.main.async() {
                    //  print("GOOGLE API MANAGER READY TO ROLL OUT")
                    self.polyline.path = self.gdata!.path
                    self.polyline.strokeWidth = 4
                    self.polyline.strokeColor = UIColor.init(hue: 210, saturation: 88, brightness: 84, alpha: 1)
                    self.polyline.map = mapView
                    // print(googleData!.)
                }
            }
            
        }
            

        
        
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    func displayAlert(title: String, errorMsg: String) {
        // create the alert
        let alert = UIAlertController(title: title, message: errorMsg, preferredStyle: UIAlertControllerStyle.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
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
