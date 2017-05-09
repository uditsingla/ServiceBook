//
//  AllVehiclesPresenter.swift
//  ServiceBook
//
//  Created by Apple on 27/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import UserNotifications

protocol AllVehicleView : NSObjectProtocol {
    
    func startLoading()

    func finishLoading()
    
    func allVehiclesReceives(arrVehicles : NSMutableArray)
    
    func vehicleDeleted() 
}

class AllVehiclesPresenter: NSObject {

    weak fileprivate var allVehicleView : AllVehicleView?

    func attachView(_ view : AllVehicleView){
        allVehicleView = view
    }
    
    func detachView() {
        allVehicleView = nil
    }
    
    func getAllVehicles()
    {
         let myPredicate = NSPredicate(format: "serviceDueDate >= %@", Date() as CVarArg)
        
        allVehicleView?.allVehiclesReceives(arrVehicles: ModelManager.sharedInstance.vehicalManager.getAllVehicles(predicate: myPredicate))
        
    }
    
    func deleteVehicle(vehicleID : String)  {
        
        ModelManager.sharedInstance.vehicalManager.deleteVehicle(vehicelID: vehicleID, completion: {
            success in
            
            self.allVehicleView?.vehicleDeleted()
        })
    }
    
    func removeNotification(arrNotificationID : [String])
    {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: arrNotificationID)
    }
    
    
    
}
