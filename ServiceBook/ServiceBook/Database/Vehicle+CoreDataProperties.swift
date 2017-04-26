//
//  Vehicle+CoreDataProperties.swift
//  ServiceBook
//
//  Created by Apple on 24/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import Foundation
import CoreData


extension Vehicle {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Vehicle> {
        return NSFetchRequest<Vehicle>(entityName: "Vehicle");
    }

    @NSManaged public var vehicleID: String?
    @NSManaged public var vehicleType: String?
    @NSManaged public var vehicleName: String?
    @NSManaged public var vehicleNo: String?
    @NSManaged public var serviceRequiredAfter: Int32
    @NSManaged public var averageRun: Int16
    @NSManaged public var lastServiceDate: NSDate?
    @NSManaged public var notes: String?
    @NSManaged public var serviceDueDate: NSDate?

}
