//
//  AppSharedInstance.swift
//  ServiceBook
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import UserNotifications

// MARK: - Extension for UNUserNotification
extension AppSharedInstance : UNUserNotificationCenterDelegate {
    
    // MARK: - UNUserNotification Delegates
    
    // The method will be called on the delegate only if the application is in the foreground.
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])

        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: notification.request.content.userInfo)
    }

    // The method will be called on the delegate when the user responded to the notification by opening the application, dismissing the notification or choosing a UNNotificationAction.
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        NotificationCenter.default.post(name: Notification.Name("NotificationIdentifier"), object: nil, userInfo: response.notification.request.content.userInfo)
        
    }
    
    
    //*********//
    //Notification Methods
    //*********//
    
    // MARK: - LocalNotification Methods

    /// Call this method to set or update local notifications
    // vehicleObj: Pass AllVehiclesI object reference
    // notificationDate: Pass notification execution date
    func setLocalNotification(vehicleObj : AllVehiclesI, notificationDate : Date)
        {
            // Create Notification Content
            let notificationContent = UNMutableNotificationContent()
            
            
            print("Uniuqe id : \(vehicleObj.vehicleID)")
            // Configure Notification Content
            notificationContent.title = "\(vehicleObj.vehicleName!)'s Service Time"
            notificationContent.subtitle = "Get Ready"
            notificationContent.body = "\(vehicleObj.vehicleNo!) \(vehicleObj.vehicleType!) needs to go to workshop"

            notificationContent.sound = UNNotificationSound.init(named: "carsound.wav")
            
            print(notificationDate)
            
            //let date = Date(timeIntervalSinceNow: 10)
            let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notificationDate)
            
            // Add Trigger W.R.T Date (Dynamic date)
            let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: false)
        
            // Add Trigger W.R.T Time
            //let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 3.0, repeats: false)
            
            
            notificationContent.userInfo = [
                                            "id": vehicleObj.vehicleID,
                                            "type" : vehicleObj.vehicleType ?? "",
                                            "name" : vehicleObj.vehicleName ?? "",
                                            "no" : vehicleObj.vehicleNo ?? "",
                                            "serviceReqAfter" : vehicleObj.serviceRequiredAfter ?? 0,
                                            "averageRun" : vehicleObj.averageRun ?? 0,
                                            "lastService" : vehicleObj.lastServiceDate!,
                                            "notes" : vehicleObj.notes ?? "",
                                            "serviceDueDate" : notificationDate
                                            ]
            
            let notificationRequest = UNNotificationRequest(identifier: "\(vehicleObj.vehicleID)", content: notificationContent, trigger: notificationTrigger)
            // Add Request to User Notification Center
            UNUserNotificationCenter.current().add(notificationRequest) { (error) in
                if let error = error {
                    print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
                }
            }
        }
    
    /// Call this method to remove all existing notifications
    // arrNotificationID: Array of notification id's in string format
    func removeNotification(arrNotificationID : [String])
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrNotificationID)
    }
}



// MARK: - Main calss which acts as a singleton
class AppSharedInstance: NSObject {

   static let sharedInstance = AppSharedInstance()
    
   let appdelegate = UIApplication.shared.delegate as! AppDelegate

    let myDateFormatter = "dd MMM yyyy"
    
    override init()
    {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    // MARK: - Genric Functions

    /// Call this method to get next service due date
    // vehicleObj: Pass AllVehiclesI object reference
    // return : Next service due date in string
    func getServiceDueDate(objVehicle : AllVehiclesI) -> String {
        
        let averageDay = Float(objVehicle.averageRun!)/7.0
        
        let noOfDays  = Float(objVehicle.serviceRequiredAfter!)/averageDay
        
        //let noOfDays = Float(objVehicle.serviceRequiredAfter!)/(averageDayRun *  7)
        
        let currentCalendar = NSCalendar.current
        
        objVehicle.serviceDueDate = currentCalendar.date(byAdding: Calendar.Component.day, value: Int(noOfDays), to: objVehicle.lastServiceDate!)
        
        let strDueDate = self.getFormattedStr(formatterType: self.myDateFormatter, dateObj: objVehicle.serviceDueDate!)
        
        print("Service due on : \(strDueDate)")
        
        return strDueDate
        
    }
    
    func getTimeDuration(startDate : String, endDate : String, formatterType : String) -> String
    {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = formatterType
        
        let sd = dateFormatterGet.date(from: startDate)
        let ed = dateFormatterGet.date(from: endDate)
        
        let form = DateComponentsFormatter()
        form.maximumUnitCount = 0
        form.unitsStyle = .full
        form.allowedUnits = [.year, .month, .day]
        let finalStr = form.string(from: sd!, to: ed!)
        
        return finalStr!
    }
    
    func getFormattedStr(formatterType : String, dateObj : Date) -> String
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterType
        dateFormatter.timeZone = NSTimeZone.local
        return dateFormatter.string(from: dateObj as Date)
    }
    
    func getFormattedDate(formatterType : String, stringObj OfDate : String) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterType
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: OfDate) ?? Date()
    }
    
    func getReadableDateFromTimeStamp(timeStamp: TimeInterval, formatterType: String? = "dd MMM yyyy") -> String? {
        let date = Date(timeIntervalSince1970: timeStamp)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = formatterType
        return dateFormatter.string(from: date)
    }
    
}
