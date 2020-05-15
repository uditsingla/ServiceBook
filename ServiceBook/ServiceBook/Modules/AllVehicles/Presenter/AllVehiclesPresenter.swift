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
    
    func deleteVehicle(vehicleID : String, gadgetObj: Gadget)  {
        
        ModelManager.sharedInstance.vehicalManager.deleteVehicle(vehicelID: vehicleID, completion: {
            success in
            self.deleteRecordOnServer(gadgetObj: gadgetObj)
            self.allVehicleView?.vehicleDeleted()
        })
    }
    
    
    func addNewVehicle(objVehicle : AllVehiclesI)
    {
        ModelManager.sharedInstance.vehicalManager.addNewVehicle(objVehicle : objVehicle, completion: {
            success in
            
            self.addNewRecordOnFirebase(objVehicle: objVehicle)
            self.getAllVehicles()
        })
    }
    
    func editVehicalInfo(objVehicle : AllVehiclesI)
    {
        ModelManager.sharedInstance.vehicalManager.editVehicalInfo(objVehicle : objVehicle, completion: {
            success in
        })
    }
    
    // MARK: - Firebase Interaction
    
    func addNewRecordOnFirebase(objVehicle : AllVehiclesI) {
        //save data in DB on Server
        //FIRFireStoreService.shared.update(for: gadgetToUpdate!, in: .gadgets)
        let gadgetInfo = Gadget.init(name: objVehicle.vehicleName ?? "",
                                     type: objVehicle.vehicleType ?? "",
                                     number: objVehicle.vehicleNo ?? "",
                                     notes: objVehicle.notes ?? "",
                                     serviceRequiredAfter: objVehicle.serviceRequiredAfter ?? 0,
                                     averageRun: objVehicle.averageRun ?? 0,
                                     lastServiceDate: objVehicle.lastServiceDate!.timeIntervalSince1970,
                                     serviceDueDate: objVehicle.serviceDueDate!.timeIntervalSince1970)
        FIRFireStoreService.shared.create(for: gadgetInfo, in: .gadgets)
        
    }
    
    func updateRecordOnServer(gadgetObj: Gadget, objVehicle : AllVehiclesI) {
        
        var gadgetObjToUpdate = gadgetObj
        gadgetObjToUpdate.vehicleName = objVehicle.vehicleName
        gadgetObjToUpdate.vehicleType = objVehicle.vehicleType ?? ""
        gadgetObjToUpdate.vehicleNo = objVehicle.vehicleNo ?? ""
        gadgetObjToUpdate.notes = objVehicle.notes ?? ""
        gadgetObjToUpdate.serviceRequiredAfter = objVehicle.serviceRequiredAfter ?? 0
        gadgetObjToUpdate.averageRun = objVehicle.averageRun ?? 0
        gadgetObjToUpdate.lastServiceDate = objVehicle.lastServiceDate!.timeIntervalSince1970
        gadgetObjToUpdate.serviceDueDate = objVehicle.serviceDueDate!.timeIntervalSince1970
        
        FIRFireStoreService.shared.update(for: gadgetObjToUpdate, in: .gadgets)
    }
    
    func deleteRecordOnServer(gadgetObj: Gadget) {
        FIRFireStoreService.shared.delete(gadgetObj, in: .gadgets)
    }
}
