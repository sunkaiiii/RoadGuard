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
    var listeners = MulticastDelegate<DatabaseListener>()

    var authController:Auth
    var database:Firestore

    var speedLimitRef:CollectionReference?
    var normalSpeedRef:CollectionReference?
    var facialRef:CollectionReference?

    var speedInforList:[SpeedRecord] = []
    var facialInfoList:[FacialInfo] = []
    
    override init(){
        FirebaseApp.configure()
        database = Firestore.firestore()
        authController = Auth.auth()
        super.init()
        authController.signInAnonymously(completion: {(authResult,error) in
            guard let authResult = authResult else{
                fatalError("Firebase authentication failed")
            }
            print("\(String(describing: authResult.user.displayName))")
            self.speedLimitRef = self.database.collection("speedLimitRecord")
            self.normalSpeedRef = self.database.collection("normalSpeedRecord")
            self.facialRef = self.database.collection("facial")
            self.setUpSpeedLimitListeners()
        })
    }

    func setUpFacialListeners(){
        self.facialRef?.addSnapshotListener({(querySnapshot,error) in
            guard let querySnapshot = querySnapshot else{
                print("Error fetching documents")
                return
            }
            self.parseFacialSnapshot(snapshot:querySnapshot)
        })
    }

    func parseFacialSnapshot(snapshot:QuerySnapshot){
        snapshot.documentChanges.forEach({(change) in
            //            let facialRecordId = chang

            var parsedFacialDocument:FacialInfo?
            do{
                parsedFacialDocument = try change.document.data(as: FacialInfo.self)
            }catch{
                print("Unable to decode the Faicial infomation record")
                return
            }

            guard let facialInfo = parsedFacialDocument else{
                print("Document does not exist")
                return
            }

            //            facialInfo.id = facialRecordId

            switch change.type{
                case .added:
                    facialInfoList.append(facialInfo)
                default:
                    ()
            }
        })
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType == .facial || listener.listenerType == .all {
                listener.onFacialInfoChange(change: .add, facialInfos: facialInfoList)
            }
        })
    }
    
    func setUpSpeedLimitListeners(){
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

    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)

        if listener.listenerType == .facial || listener.listenerType == .all{
            listener.onFacialInfoChange(change: .add, facialInfos: facialInfoList)
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}

protocol DatabaseProtocol:NSObject {
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func addOverSpeedRecord(_ record:SpeedRecord)->SpeedRecord
    func addNormalSpeedRecord(_ record:SpeedRecord)->SpeedRecord
}
protocol DatabaseListener:AnyObject {
    var listenerType:ListenerType{get set}
    func onFacialInfoChange(change:DatabaseChange, facialInfos:[FacialInfo])
}
enum ListenerType {
    case facial

    case all
}
enum DatabaseChange {
    case add
    case remove
    case update
}
