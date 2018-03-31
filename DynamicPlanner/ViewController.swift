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

    @IBOutlet weak var datePickerText: UITextField!
    
    let datePicker = UIDatePicker()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Asked for permission
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        UNUserNotificationCenter.current().delegate = self
        createDatePicker()
        
        
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
        // Setting up Timer based on Calendar:
        //Calendar: Trigger at a specific date and time. The trigger is created using a date components object which makes it easier for certain repeating intervals. To convert a Date to its date components use the current calendar.
        
        
        
     //  let date = Date(timeIntervalSinceNow: 3600)
        
//        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        //************************** Creating trigger from date components
        
       // let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        print("***********")
       // print(trigger)
        print("***********")
        
        
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
    
    func createDatePicker()
    {
        // Creating our scheduled based of UIPicker, this format will include year, month, day, hour and minutes, seconds

        
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action:#selector(donePressed))
        toolBar.setItems([doneButton], animated: false)
        datePickerText.inputAccessoryView = toolBar
        // assigning date picker to text field.
        datePickerText.inputView = datePicker
        
    }
    
    @objc func donePressed()
    {
         let date = datePicker.date
        
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
        
        
      
        
        let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
        //************************** Creating trigger from date components
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        print("*********** Picked time for notification")
        print(trigger)
        print("***********")
        
        //This line only applies to testing purposes, this is a 5 second response
        //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        let request = UNNotificationRequest(identifier:"timerDone", content: content, trigger:trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
        
        
        let center = UNUserNotificationCenter.current()
        center.setNotificationCategories([generalCategory, expiredCategory])
        
        
        
        
        //format date
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .none
        datePickerText.text = "\(datePicker.date)"
        //datePickerText.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    
    
}

