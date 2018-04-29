//
//  ViewController.swift
//  DynamicPlanner
//
//  Created by Jesus Perez on 3/29/18.
//  Copyright © 2018 Jesus Perez. All rights reserved.
//

import UIKit
import UserNotifications

class ViewController: UIViewController, UNUserNotificationCenterDelegate, DateTimePickerDelegate {

    @IBOutlet weak var datePickerText: UITextField!
    
    @IBOutlet weak var dypl_desc: UITextView!
    @IBOutlet weak var dypl_title: UITextField!
    
    let datePicker = UIDatePicker()
     var picker: DateTimePicker?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: {didAllow, error in
        })
        UNUserNotificationCenter.current().delegate = self
          self.title = "Date Time Picker"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

   
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void)
    {
        if(response.actionIdentifier == "SNOOZE_ACTION")
        {
             // Creating a date object for another trigger, this mimics snooze functionality.
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
            let content = UNMutableNotificationContent()
                    content.title = "Snooze is over! Time to wake up!!"
                   // content.subtitle = "They are up now"
                    content.body = "Wake up! Wake up! Wake up!"
                    content.categoryIdentifier = "TIMER_EXPIRED"
                    //content.badge = 1
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 20, repeats: false)
            let request = UNNotificationRequest(identifier:"timerDone", content: content, trigger:trigger)
                    UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            let center = UNUserNotificationCenter.current()
                    center.setNotificationCategories([generalCategory, expiredCategory])
           // print ("snooze for an alotted time")
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
    

    func dateTimePicker(_ picker: DateTimePicker, didSelectDate: Date) {
        title = picker.selectedDateString
    }
    
    @IBAction func setAlarm(_ sender: Any) {
        
        
        //Added updated DateTimePicker
        let min = Date().addingTimeInterval(-60 * 60 * 24 * 4)
        let max = Date().addingTimeInterval(60 * 60 * 24 * 4)
        let picker = DateTimePicker.show(selected: Date(), minimumDate: min, maximumDate: max)
        picker.timeInterval = DateTimePicker.MinuteInterval.default
        picker.highlightColor = UIColor(red: 12.0/255.0, green: 14.0/255.0, blue: 63.0/255.0, alpha: 1)
        picker.darkColor = UIColor.darkGray
        picker.doneButtonTitle = "Done"
        picker.doneBackgroundColor = UIColor(red: 12.0/255.0, green: 14.0/255.0, blue: 63.0/255.0, alpha: 1)
        picker.locale = Locale(identifier: "en_GB")
        
        picker.todayButtonTitle = "Today"
        picker.is12HourFormat = true
        picker.dateFormat = "hh:mm aa dd/MM/YYYY"
        //        picker.isTimePickerOnly = true
        picker.includeMonth = false // if true the month shows at top
        picker.completionHandler = { date in
            print("This is the date")
            print(date)
            
            //***************************************************
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
            content.title = self.dypl_title.text!
            content.body = self.dypl_desc.text!
            content.categoryIdentifier = "TIMER_EXPIRED"
            
            
            let triggerDate = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date)
            //************************** Creating trigger from date components
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
            print("********************** Picked time for notification")
            print(trigger)
            print("**********************")
            
            //This line only applies to testing purposes, this is a 5 second response
            //let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
            let request = UNNotificationRequest(identifier:"timerDone", content: content, trigger:trigger)
            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            
            
            let center = UNUserNotificationCenter.current()
            center.setNotificationCategories([generalCategory, expiredCategory])
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm aa dd/MM/YYYY"
           // self.title = formatter.string(from: date)
        }
       // picker.delegate = self
       //self.picker = picker
        // createDatePicker()
        
    }
    
}

