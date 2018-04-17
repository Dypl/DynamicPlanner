//
//  GoogleMatrixData.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 4/15/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation
import GoogleMaps
import GooglePlaces

class GoogleMatrixData {
    
    var path : GMSPath!
    
    
    init(dictionary: [String: Any]) {
        
                        if let array = dictionary["routes"] as? NSArray {
                            print("hi")
                            if let routes = array[0] as? NSDictionary{
                                if let overview_polyline = routes["overview_polyline"] as? NSDictionary{
                                    if let points = overview_polyline["points"] as? String{
                                       path = GMSPath(fromEncodedPath:points)
                                        print("print path here")
                                        print(path)
                                    }
                                }
                            }
                        }
        
        
    }
}
