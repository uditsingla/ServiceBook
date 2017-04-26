//
//  VehicleManager.swift
//  ServiceBook
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class VehicleManager: NSObject {
    
    var arrVehicles : NSMutableArray = NSMutableArray()

    func addNewVehicle(objVehicle : AllVehiclesI, completion : @escaping (Bool) -> Void)  {
                
        ModelManager.sharedInstance.dbManager.addRecord(objVehicle: objVehicle, entityName: "Vehicle" , completion: {
             success in
            
            completion(success)
        })
    }
    
    func deleteVehicle(vehicelID : String)  {
        
         ModelManager.sharedInstance.dbManager.deleteRecord(recordID: vehicelID , entityName: "Vehicle")
    }
    
    func updateVehileInfo(dictData : NSMutableDictionary)  {
        
    }
    
    func getAllVehicles(dictData : NSMutableDictionary)
    {
        
    }
}
