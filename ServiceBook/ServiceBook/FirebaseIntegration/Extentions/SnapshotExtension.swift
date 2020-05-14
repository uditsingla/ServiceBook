//
//  SnapshotExtension.swift
//  FirebaseDemo
//
//  Created by Abhishek Singla on 07/05/20.
//  Copyright © 2020 Abhishek Singla. All rights reserved.
//

import Foundation
import FirebaseFirestore

extension DocumentSnapshot {
    func decode<T: Decodable>(as objectType: T.Type, includingId: Bool = true) throws -> T {
       
        var documentJson = data()
        if includingId {
            documentJson!["id"] = documentID
        }
        
        let documentData = try JSONSerialization.data(withJSONObject: documentJson!, options: [])
        let decodedObj = try JSONDecoder().decode(objectType, from: documentData)
        return decodedObj
    }
}
