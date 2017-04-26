//
//  ModelManager.swift
//  ServiceBook
//
//  Created by Apple on 25/04/17.
//  Copyright © 2017 abhi. All rights reserved.
//

import UIKit

class ModelManager: NSObject {
    
    var authManager : AuthenticationManager
    var dbManager : DatabaseManager
    var vehicalManager : VehicleManager
    
    static let sharedInstance = ModelManager()
    
    private override init() {
        
        authManager = AuthenticationManager()
        dbManager =  DatabaseManager()
        vehicalManager = VehicleManager()
        
    }
    
}
