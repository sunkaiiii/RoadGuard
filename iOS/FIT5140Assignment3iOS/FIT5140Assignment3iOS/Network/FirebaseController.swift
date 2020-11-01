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
    var speedInforList:[SpeedRecord] = []
    
    
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
            self.setUpListeners()
        })
    }
    
    func setUpListeners(){
        self.speedLimitRef?.addSnapshotListener({(querySnapshot,error) in
            guard let querySnapshot = querySnapshot else{
                print("Error fetching documents")
                return
            }
            self.parseSpeedLimitSnapshot(snapshot:querySnapshot)
        })
    }
    
    func parseSpeedLimitSnapshot(snapshot:QuerySnapshot){
        snapshot.documentChanges.forEach({(change) in
            let speedRecordId = change.document.documentID
            print(speedRecordId)
            var parsedSpeedDocument:SpeedRecord?
            
            do{
                parsedSpeedDocument = try change.document.data(as: SpeedRecord.self)
            }catch{
                print("Unable to decode the speed record")
                return
            }
            
            guard let speedRecord = parsedSpeedDocument else{
                print("Document does not exist")
                return
            }
            
            speedRecord.id = speedRecordId
            switch change.type{
            case .added:
                speedInforList.append(speedRecord)
            case .modified:
                if let index = getSpeedRecordById(id: speedRecordId) {
                    speedInforList[index] = speedRecord
                }
            case .removed:
                if let index = getSpeedRecordById(id: speedRecordId){
                    speedInforList[index] = speedRecord
                }
            }
        })
    }
    
    func getSpeedRecordById(id:String)->Int?{
        return speedInforList.firstIndex(where: {(speed) in
            speed.id == id
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
