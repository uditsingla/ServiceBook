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
}
