//
//  ApiKeys.swift
//  DynamicPlanner
//
//  Created by Nicholas Rosas on 3/29/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

func valueForAPIKey(named keyname:String) -> String{
    let filePath = Bundle.main.path(forResource: "ApiKeys", ofType: "plist")
    let plist = NSDictionary(contentsOfFile: filePath!)
    let value = plist?.object(forKey: keyname) as! String
    return value
}
