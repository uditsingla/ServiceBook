//
//  HistoryPresenter.swift
//  ServiceBook
//
//  Created by Apple on 08/05/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

protocol HistoryView: NSObjectProtocol {
    
    func startLoading()
    func finishLoading()
    
    func allVehiclesReceives(arrVehicles : NSMutableArray)

    func vehicleDeleted()
}


class HistoryPresenter: NSObject {

    
     weak fileprivate var historyView : HistoryView?
    
    func attachView(_ view : HistoryView){
        historyView = view
    }
    
    func detachView() {
        historyView = nil
    }
    
    func getAllVehicles()
    {
        
        let myPredicate = NSPredicate(format: "serviceDueDate < %@", Date() as CVarArg)
        historyView?.allVehiclesReceives(arrVehicles: ModelManager.sharedInstance.vehicalManager.getAllVehicles(predicate: myPredicate))
    }
    
    func deleteVehicle(vehicleID : String)  {
        
        ModelManager.sharedInstance.vehicalManager.deleteVehicle(vehicelID: vehicleID, completion: {
            success in
            
            self.historyView?.vehicleDeleted()
        })
    }
}
