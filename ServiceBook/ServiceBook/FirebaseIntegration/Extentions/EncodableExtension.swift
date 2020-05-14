//
//  EncodableExtension.swift
//  FirebaseDemo
//
//  Created by Abhishek Singla on 07/05/20.
//  Copyright © 2020 Abhishek Singla. All rights reserved.
//

import Foundation

enum MyError: Error {
    case encodingError
}

extension Encodable {
    func toJson(excluding keys:[String] = [String]()) throws -> [String: Any] {
        let objData = try JSONEncoder().encode(self)
        let jsonObj = try JSONSerialization.jsonObject(with: objData, options: [])
        guard var json = jsonObj as? [String: Any] else { throw MyError.encodingError }
        
        for key in keys {
            json[key] = nil
        }
        
        return json
    }
}
