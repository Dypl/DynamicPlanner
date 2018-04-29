//
//  EdamamAPIManager.swift
//  DynamicPlanner
//
//  Created by Carlos Huizar-Valenzuela on 4/2/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

class EdamamAPIManager {
    static let applicationID = "46ccc9db"
    static let applicationAPIKey = "c3e20321474a79c888ba0fbc1f731610"
    static let callbackURLString = "https://api.edamam.com/search?q=breakfast&app_id=46ccc9db&app_key=c3e20321474a79c888ba0fbc1f731610"
    var session: URLSession
    
    init() {
        session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    }
    
    func edamam(completion: @escaping ([[String: Any]]?, Error?) -> ()) {
        let url = URL(string: EdamamAPIManager.callbackURLString)!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        completion([], nil)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let data = data {
                let dataDict = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let hits = dataDict["hits"] as! [[String: Any]]
                completion(hits, nil)
            } else {
                completion(nil, error)
            }
        }
        task.resume()
    }
    
}
