//
//  FirebaseController.swift
//  FIT5140Assignment3iOS
//
//  Created by sunkai on 28/10/20.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift

class FirebaseController: NSObject,DatabaseProtocol {
    
    var authController:Auth
    var database:Firestore
    var speedLimitRef:CollectionReference?
    var normalSpeedRef:CollectionReference?
    
    
    override init(){
        FirebaseApp.configure()
        database = Firestore.firestore()
        authController = Auth.auth()
        super.init()
        authController.signInAnonymously(completion: {(authResult,error) in
            guard let authResult = authResult else{
                fatalError("Firebase authentication failed")
            }
            print("authResult.user.displayName")
            self.speedLimitRef = self.database.collection("speedLimitRecord")
            self.normalSpeedRef = self.database.collection("normalSpeedRecord")
        })
    }
    
    func addOverSpeedRecord(_ record: SpeedRecord)->SpeedRecord {
        do{
            if let overspeedRef = try speedLimitRef?.addDocument(from: record){
                record.id = overspeedRef.documentID
            }
        }catch{
            print("Failed to serilise over speed record")
        }
        return record
    }
    
    func addNormalSpeedRecord(_ record: SpeedRecord) -> SpeedRecord {
        do{
            if let overspeedRef = try normalSpeedRef?.addDocument(from: record){
                record.id = overspeedRef.documentID
            }
        }catch{
            print("Failed to serilise over speed record")
        }
        return record
    }
    
}

protocol DatabaseProtocol:NSObject {
    func addOverSpeedRecord(_ record:SpeedRecord)->SpeedRecord
    func addNormalSpeedRecord(_ record:SpeedRecord)->SpeedRecord
}
