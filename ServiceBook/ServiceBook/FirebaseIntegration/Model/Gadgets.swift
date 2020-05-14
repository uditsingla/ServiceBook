//
//  Gadgets.swift
//  ServiceBook
//
//  Created by Abhishek Singla on 14/05/20.
//  Copyright © 2020 abhi. All rights reserved.
//

import Foundation

protocol Identifiable {
    var id: String? {get set}
}

struct Gadget: Codable, Identifiable {
    
    var id: String? = nil
    var vehicleType: String? = nil
    var vehicleName: String? = nil
    var vehicleNo: String? = nil
    var notes: String? = nil
    var serviceRequiredAfter: Int? = nil
    var averageRun: Int? = nil
    var lastServiceDate: Double? = nil
    var serviceDueDate: Double? = nil
    
    
    init(name: String, type: String, number: String, notes: String, serviceRequiredAfter: Int, averageRun: Int, lastServiceDate: Double, serviceDueDate: Double) {
        self.vehicleName = name
        self.vehicleType = type
        self.vehicleNo = number
        self.notes = notes
        self.serviceRequiredAfter = serviceRequiredAfter
        self.averageRun = averageRun
        self.lastServiceDate = lastServiceDate
        self.serviceDueDate = serviceDueDate
    }
}
