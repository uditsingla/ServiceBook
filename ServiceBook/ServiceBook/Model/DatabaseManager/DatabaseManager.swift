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
        vehicleEntity.serviceRequiredAfter = Int32(objVehicle.serviceRequiredAfter!)
        vehicleEntity.lastServiceDate = objVehicle.lastServiceDate as NSDate?
        vehicleEntity.serviceDueDate = objVehicle.serviceDueDate as NSDate?
        vehicleEntity.averageRun = Int16((objVehicle.averageRun! as Int?)!)
        vehicleEntity.vehicleNo = objVehicle.vehicleNo
        vehicleEntity.notes = objVehicle.notes

        //save the object
        do {
            try self.managedObjectContext.save()
            completion(true)
            print("record saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
             completion(false)
        } catch {
            completion(false)
        }

    }
    
    func editRecord(objVehicle : AllVehiclesI, entityName : String, completion: @escaping (Bool) -> Void)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let predicate = NSPredicate(format: "vehicleID == %@",objVehicle.vehicleID)

        let sortDescriptor = NSSortDescriptor(key: "serviceDueDate", ascending: true)
        let sortDescriptors = [sortDescriptor]
        
        fetchRequest.sortDescriptors = sortDescriptors
        fetchRequest.predicate = predicate
        
        
        do {
            let result = try self.managedObjectContext.fetch(fetchRequest)
            print(result)
            
            if(result.count>0)
            {
                let obj : Vehicle = result[0] as! Vehicle
                
                obj.vehicleType = objVehicle.vehicleType!
                obj.vehicleID = objVehicle.vehicleID
                obj.vehicleName = objVehicle.vehicleName
                obj.serviceRequiredAfter = Int32(Int(objVehicle.serviceRequiredAfter!))
                obj.lastServiceDate = objVehicle.lastServiceDate as NSDate?
                obj.averageRun = Int16(objVehicle.averageRun!)
                obj.vehicleNo = objVehicle.vehicleNo
                obj.notes = objVehicle.notes
                obj.serviceDueDate = objVehicle.serviceDueDate as NSDate?
                
                print("something")
               
            }
            try self.managedObjectContext.save()
            completion(true)
        }            
         catch let error as NSError  {
            completion(false)
            print("Could not update \(error), \(error.userInfo)")
        } catch {
            completion(false)
        }
        

    }
    
    func deleteRecord(recordID : String,  entityName : String, completion: @escaping (Bool) -> Void)  {
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: entityName)
        
        let predicate = NSPredicate(format: "vehicleID == %@", recordID)
        fetchRequest.predicate = predicate
        
        
        let result = try? self.managedObjectContext.fetch(fetchRequest)
        let resultData = result
        
        for object in resultData! {
            self.managedObjectContext.delete(object)
        }
        
        do {
            try self.managedObjectContext.save()
             completion(true)
            print("deleted!")
        } catch let error as NSError  {
             completion(false)
            print("Could not delete \(error), \(error.userInfo)")
        } catch {
             completion(false)
        }

        
    }
    
    func updateRecord(recordID : String, dictData : NSMutableDictionary , entityName : String)   {
        
    }
    
    func getAllRecords(entityName : String, predicate : NSPredicate?) -> NSMutableArray?
    {
        
        // Initialize Fetch Request
        //let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        let fetchRequest: NSFetchRequest<Vehicle> = Vehicle.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "serviceDueDate", ascending: true)
        let sortDescriptors = [sortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors

        if(predicate  != nil)
        {
            fetchRequest.predicate = predicate
        }
        
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
                    
                    allVehicle.vehicleType = obj.vehicleType!
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
    
    return NSMutableArray()
        
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
