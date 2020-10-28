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
        })
    }
    
    func addOverSpeedRecord(_ record: OverSpeedRecord)->OverSpeedRecord {
        do{
            if let overspeedRef = try speedLimitRef?.addDocument(from: record){
                record.id = overspeedRef.documentID
            }
        }catch{
            print("Failed to serilise over speed record")
        }
        return record
    }
    
}

protocol DatabaseProtocol:NSObject {
    func addOverSpeedRecord(_ record:OverSpeedRecord)->OverSpeedRecord
}
