//
//  ViewController.swift
//  DynamicPlanner
//
//  Created by Jesus Perez on 3/29/18.
//  Copyright © 2018 Carlos Huizar-Valenzuela. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        UNUserNotificationCenter.current().delegate = self
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func alert(_ sender: Any) {
        
        //setting up actions
        
        let generalCategory = UNNotificationCategory(identifier: "GENERAL",
                                                     actions: [],
                                                     intentIdentifiers: [],
                                                     options: .customDismissAction)
        
        // Create the custom actions for the TIMER_EXPIRED category.
        let snoozeAction = UNNotificationAction(identifier: "SNOOZE_ACTION",
                                                title: "Snooze",
                                                options: UNNotificationActionOptions(rawValue: 0))
        let stopAction = UNNotificationAction(identifier: "STOP_ACTION",
                                              title: "Stop",
                                              options: .foreground)
        
        let expiredCategory = UNNotificationCategory(identifier: "TIMER_EXPIRED",
                                                     actions: [snoozeAction, stopAction],
                                                     intentIdentifiers: [],
                                                     options: UNNotificationCategoryOptions(rawValue: 0))
        
        //***** TO DO: Create an alarm clock that will determine the time the local notification must be displayed
        let content = UNMutableNotificationContent()
        content.title = "The 5 seconds are up!"
        content.subtitle = "They are up now"
        content.body = "The 5 seconds are really up man"
        content.categoryIdentifier = "TIMER_EXPIRED"
        content.badge = 1
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier:"timerDone", content: content, trigger:trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
      
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory, expiredCategory])
    }
    // handling the user response
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if(response.actionIdentifier == "SNOOZE_ACTION")
        {
            print ("snooze for an alotted time")
        }
        else if(response.actionIdentifier == "STOP_ACTION")
        {
            print ("STOP ALERT")
        }
        else{
            print("Error 404")
        }
        
        completionHandler()
    }
    
    
}

