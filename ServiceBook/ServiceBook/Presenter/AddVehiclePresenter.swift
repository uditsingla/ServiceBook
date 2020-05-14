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
            
            //Save record on Server
            self.addNewRecordOnFirebase(isNewRecord: true, objVehicle: objVehicle)

            self.addVehicleView?.newVehicleAdded(isSuccess: true)


        })
    }
    
    func editVehicalInfo(objVehicle : AllVehiclesI)
    {
        ModelManager.sharedInstance.vehicalManager.editVehicalInfo(objVehicle : objVehicle, completion: {
            success in
            
            self.addNewRecordOnFirebase(isNewRecord: false, objVehicle: objVehicle)
            
            self.addVehicleView?.vehicleInfoUpdated(isSuccess: true)
        })
    }
    
    
    func addNewRecordOnFirebase(isNewRecord: Bool, objVehicle : AllVehiclesI) {
        //save data in DB on Server
        if isNewRecord {
            let gadgetInfo = Gadget.init(name: objVehicle.vehicleName ?? "",
                                       type: objVehicle.vehicleType ?? "",
                                       number: objVehicle.vehicleNo ?? "",
                                       notes: objVehicle.notes ?? "",
                                       serviceRequiredAfter: objVehicle.serviceRequiredAfter ?? 0,
                                       averageRun: objVehicle.averageRun ?? 0,
                                       lastServiceDate: objVehicle.lastServiceDate!.timeIntervalSince1970,
                                       serviceDueDate: objVehicle.serviceDueDate!.timeIntervalSince1970)
            FIRFireStoreService.shared.create(for: gadgetInfo, in: .gadgets)

        } else {
            //FIRFireStoreService.shared.update(for: gadgetToUpdate!, in: .gadgets)
        }
    }
}
