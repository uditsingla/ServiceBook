//
//  FIRFireStoreService.swift
//  FirebaseDemo
//
//  Created by Abhishek Singla on 07/05/20.
//  Copyright © 2020 Abhishek Singla. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

class FIRFireStoreService {
    
    static let shared = FIRFireStoreService()
    
    private init() {
    }
    
    private func refrence(to collectionReference: FIRCollectionReference) -> CollectionReference {
        return Firestore.firestore().collection(collectionReference.rawValue)
    }
    
    func configure() {
        FirebaseApp.configure()
    }
    
    func  create<T: Encodable>(for codableObject: T, in collectionReference: FIRCollectionReference) {
        do{
            let json = try codableObject.toJson(excluding: ["id"])
            refrence(to: collectionReference).addDocument(data: json)
        } catch {
          print(error)
        }
    }
    
    func read<T: Decodable>(from collectionReference: FIRCollectionReference, returning objectType: T.Type, completion: @escaping([T])->Void) {
        refrence(to: collectionReference).addSnapshotListener { (snapshot, _) in
            guard let snapshot = snapshot else { return }
            do{
                var objects = [T]()
                for document in snapshot.documents {
                    let object = try document.decode(as: objectType.self)
                    objects.append(object)
                }
                completion(objects)
            } catch { 
                print(error)
            }
        }
    }
    
    func update<T: Encodable & Identifiable>(for encodableObject: T, in collectionReference: FIRCollectionReference) {
        do{
            let json = try encodableObject.toJson(excluding: ["id"])
            guard let id =  encodableObject.id else { throw MyError.encodingError }
            refrence(to: collectionReference).document(id).setData(json)
        } catch {
            print(error)
        }
        
    }
    
    func delete<T: Identifiable>(_ idetifiableObject: T, in collectionReference: FIRCollectionReference) {
        do{
            guard let id = idetifiableObject.id else {throw MyError.encodingError}
            refrence(to: collectionReference).document(id).delete()
        } catch {
            print(error)
        }
    }
}
