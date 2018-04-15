//
//  GoogleData.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 4/15/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class GoogleDistanceData {
    
    
    var destination_addresses: String!
    var origin_addresses: String!
    var distance: String!
    var duration_eta: String!
    
    
    init(dictionary: [String: Any]) {
        if let array = dictionary["rows"] as? NSArray {
            print("Yes we entered here")
            if let rows = array[0] as? NSDictionary{
                if let array2 = rows["elements"] as? NSArray{
                    if let elements = array2[0] as? NSDictionary{
                        if let duration = elements["duration"] as? NSDictionary {
                            if let text = duration["text"] as? String{
                                duration_eta = text
                               
                            }
                        }
                        
                        if let duration = elements["distance"] as? NSDictionary {
                            if let text = duration["text"] as? String{
                                distance = text
                               
                            }
                        }
                    }
                }
            }
        }
    }
}
