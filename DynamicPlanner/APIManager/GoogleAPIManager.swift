//
//  GoogleAPIManager.swift
//  DynamicPlanner
//
//  Created by Jesus perez on 4/11/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import Foundation

final class GoogleApiManager {
    // Can't init it is a singleton
    init() {}
    // MARK: Shared Instance
    static let sharedInstance = GoogleApiManager()
    // MARK: Local Variable
    static let baseUrl = "https://maps.googleapis.com/maps/api/"
    static let apiKey = valueForAPIKey(named: "GOOGLE_API_KEY")
    var session =  URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
    
    
   
    
    func searchDistanceMatrixAPI(lat: String, lon: String,completion: @escaping (GoogleMatrixData?, Error?) -> ()) {
        
        //    let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(a_coordinate_string)&destinations=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
        
        //let url = URL(string: GoogleApiManager.baseUrl + "distancematrix/json?units=imperial&origins=\(lat)&destinations=\(lon)&key=\(GoogleApiManager.apiKey)")!
    let url = URL(string: GoogleApiManager.baseUrl + "directions/json?origin=\(lat)&destination=\(lon)&key=\(GoogleApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)

        
//        let task = session.dataTask(with: request) { (data, response, error) in
//            // This will run when the network request returns
//            if let data = data {
//                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                let gData = GoogleMatrixData(dictionary: dataDictionary)
//                completion(gData, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
                print(json)
                let gdata = GoogleMatrixData(dictionary: json as! [String : Any])
                completion(gdata, nil)
            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }

        })
        
        
        
        task.resume()
        

    }
    func searchDirectionsAPI(lat: String, lon: String,completion: @escaping (GoogleDistanceData?, Error?) -> ()) {
        
        //        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
        // We need to handle API KEYS: IN APP DELEGATE & WITHIN THIS ENDPOINT.
        
       // let url = URL(string: GoogleApiManager.baseUrl + "directions/json?origin=\(lat)&destination=\(lon)&key=\(GoogleApiManager.apiKey)")!
         let url = URL(string: GoogleApiManager.baseUrl + "distancematrix/json?units=imperial&origins=\(lat)&destinations=\(lon)&key=\(GoogleApiManager.apiKey)")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        
        

//        let task = session.dataTask(with: request) { (data, response, error) in
//            // This will run when the network request returns
//            if let data = data {
//                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
//                print(dataDictionary)
//                let gData = GoogleDistanceData(dictionary: dataDictionary)
//
//                completion(gData, nil)
//            } else {
//                completion(nil, error)
//            }
//        }
        let task = session.dataTask(with: request, completionHandler: { (data, response, error) in

            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary else {
                    throw JSONError.ConversionFailed
                }
               // print(json)
                let gdata = GoogleDistanceData(dictionary: json as! [String : Any] )
                completion(gdata, nil)

            } catch let error as JSONError {
                print(error.rawValue)
            } catch let error as NSError {
                print(error.debugDescription)
            }

        })

        
        
        task.resume()
        
        
    }
    enum JSONError: String, Error {
        case NoData = "ERROR: no data"
        case ConversionFailed = "ERROR: conversion from JSON failed"
    }
    
    
//    let urlString = "https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&origins=\(a_coordinate_string)&destinations=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
    
    
    //        let urlString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(a_coordinate_string)&destination=\(b_coordinate_string)&key=AIzaSyBpYSil4z6B-zjaSAsXlBzBl3O9TucBoZ8"
    // We need to handle API KEYS: IN APP DELEGATE & WITHIN THIS ENDPOINT.
   
}



