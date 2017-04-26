//
//  DatabaseManager.swift
//  ServiceBook
//
//  Created by Apple on 24/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager: NSObject {
    
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func addRecord(objVehicle : AllVehiclesI, entityName : String, completion: @escaping (Bool) -> Void)
    {
        //insert new record in db
        let vehicleEntity = NSEntityDescription.insertNewObject(forEntityName: entityName,into: self.managedObjectContext) as! Vehicle
        
        vehicleEntity.vehicleID = objVehicle.vehicleID
        vehicleEntity.vehicleName = objVehicle.vehicleName
        vehicleEntity.vehicleType = objVehicle.vehicleType
        vehicleEntity.serviceRequiredAfter = Int32(objVehicle.serviceRequiredAfter)
        vehicleEntity.lastServiceDate = objVehicle.lastServiceDate as NSDate?
        vehicleEntity.serviceDueDate = objVehicle.serviceDueDate as NSDate?
        vehicleEntity.averageRun = Int16((objVehicle.averageRun! as Int?)!)
        vehicleEntity.vehicleNo = objVehicle.vehicleNo
        vehicleEntity.notes = objVehicle.notes

        //save the object
        do {
            try self.managedObjectContext.save()
            completion(true)
            print("saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
             completion(false)
        } catch {
            completion(false)
        }

    }
    
    func deleteRecord(recordID : String ,entityName : String)  {
        
    }
    
    func updateRecord(recordID : String, dictData : NSMutableDictionary , entityName : String)   {
        
    }
    
    func getAllRecords(predicate : NSPredicate, entityName : String) -> NSMutableArray?
    {
        
        // Initialize Fetch Request
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "serviceDueDate", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            print(result)
            
            if(result.count>0)
            {
                let arrVehicles :NSMutableArray = NSMutableArray()
                
                for i in 0 ..< result.count
                {
                    
                    let obj : Vehicle = result[i]
                    let allVehicle : AllVehiclesI = AllVehiclesI()
                    
                    allVehicle.vehicleID = obj.vehicleID!
                    allVehicle.vehicleName = obj.vehicleName
                    allVehicle.serviceRequiredAfter = Int(obj.serviceRequiredAfter)
                    allVehicle.lastServiceDate = obj.lastServiceDate as? Date
                    allVehicle.averageRun = Int(obj.averageRun)
                    allVehicle.vehicleNo = obj.vehicleNo
                    allVehicle.notes = obj.notes
                    allVehicle.serviceDueDate = obj.serviceDueDate as? Date
                    
                    
                    arrVehicles.add(allVehicle)
                    
                }
                return arrVehicles
            }
    
    
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    
    return nil
        
    }
    
    func deleteAllRecords(entityName : String){
        
        let delRecordVar = NSBatchDeleteRequest(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: entityName))
        do {
            try self.managedObjectContext.execute(delRecordVar)
        }
        catch {
            print(error)
        }
    }
}
