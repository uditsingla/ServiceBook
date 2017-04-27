//
//  AllVehiclesPresenter.swift
//  ServiceBook
//
//  Created by Apple on 27/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

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
        allVehicleView?.allVehiclesReceives(arrVehicles: ModelManager.sharedInstance.vehicalManager.getAllVehicles())
        
    }
    
    func deleteVehicle(vehicleID : String)  {
        
        ModelManager.sharedInstance.vehicalManager.deleteVehicle(vehicelID: vehicleID, completion: {
            success in
            
            self.allVehicleView?.vehicleDeleted()
            
        })
        
        
        
    }
    
}
