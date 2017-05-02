//
//  AddVehiclePresenter.swift
//  ServiceBook
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import UserNotifications

protocol AddVehicleView: NSObjectProtocol {
    
    func startLoading()
    func finishLoading()

    func newVehicleAdded(isSuccess : Bool)
    
    func vehicleInfoUpdated(isSuccess : Bool)    
}

class AddVehiclePresenter: NSObject {
    
    weak fileprivate var addVehicleView : AddVehicleView?

    
    func attachView(_ view : AddVehicleView){
        addVehicleView = view
    }
    
    func detachView() {
        addVehicleView = nil
    }
    
    func addVehicle(objVehicle : AllVehiclesI)
    {
        ModelManager.sharedInstance.vehicalManager.addNewVehicle(objVehicle : objVehicle, completion: {
            success in
            
           self.addVehicleView?.newVehicleAdded(isSuccess: true)
            
        })
    }
    
    func editVehicalInfo(objVehicle : AllVehiclesI)
    {
        ModelManager.sharedInstance.vehicalManager.editVehicalInfo(objVehicle : objVehicle, completion: {
            success in
            
            self.addVehicleView?.vehicleInfoUpdated(isSuccess: true)
            
        })
    }
    
    
    func getServiceDueDate(objVehicle : AllVehiclesI) -> String {
        
        let averageDayRun  = Float(objVehicle.serviceRequiredAfter!)/Float(objVehicle.averageRun!)
        
        let noOfDays = Float(objVehicle.serviceRequiredAfter!)/averageDayRun
        
        let currentCalendar = NSCalendar.current
        
        objVehicle.serviceDueDate = currentCalendar.date(byAdding: Calendar.Component.day, value: Int(noOfDays), to: objVehicle.lastServiceDate!)
        
        let strDueDate = AppSharedInstance.sharedInstance.getFormattedStr(formatterType: AppSharedInstance.sharedInstance.myDateFormatter, dateObj: objVehicle.serviceDueDate!)
        
        print("Service due on : \(strDueDate)")
        
        return strDueDate
        
    }
    
    func setLocalNotification(strUniqueID : String, notificationDate : Date)
    {
        // Create Notification Content
        let notificationContent = UNMutableNotificationContent()
        
        
        print("Uniuqe id : \(strUniqueID)")
        // Configure Notification Content
        notificationContent.title = "Service Required"
        notificationContent.subtitle = "Get Ready"
        notificationContent.body = "You should go to see a workshop"
        
        print("\(notificationDate)")
        //let date = Date(timeIntervalSinceNow: 10)
        let triggerDate = Calendar.current.dateComponents([.year,.month,.day,.hour,.minute,.second,], from: notificationDate)
        let notificationTrigger = UNCalendarNotificationTrigger(dateMatching: triggerDate,
                                                                repeats: false)
        
        
        // Add Trigger W.R.T Time
        //        let notificationTriggerTest = UNTimeIntervalNotificationTrigger(timeInterval: 10.0, repeats: false)
        //
        //        // Create Notification Request
        //        let notificationRequestTest = UNNotificationRequest(identifier: "cocoacasts_local_notification", content: notificationContent, trigger: notificationTriggerTest)
        
        let notificationRequest = UNNotificationRequest(identifier: "\(strUniqueID)", content: notificationContent, trigger: notificationTrigger)
        // Add Request to User Notification Center
        UNUserNotificationCenter.current().add(notificationRequest) { (error) in
            if let error = error {
                print("Unable to Add Notification Request (\(error), \(error.localizedDescription))")
            }
        }
    }
    
    func removeNotification(arrNotificationID : [String])
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrNotificationID)
    }
    
}
