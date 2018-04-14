//
//  GoogleAPIManager.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 4/11/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class GoogleApiManager {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/"
    static let apiKey = valueForAPIKey(named: "GOOGLE_API_KEY")
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
   
}
