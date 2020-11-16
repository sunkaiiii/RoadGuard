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
    var selectedRoadRef:CollectionReference?
    var drivingRecordRef:CollectionReference?

    var speedInforList:[SpeedRecord] = []
    var facialInfoList:[FacialInfo] = []
    var selectedRoadaList:[UserSelectedRoadResponse] = []
    var drivingRecordList:[DrivingRecordResponse] = []
    
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
            self.selectedRoadRef = self.database.collection("selectedRoad")
            self.drivingRecordRef = self.database.collection("drivingRecord")
            self.setUpDrivingRecordListeners()
            self.setUpSpeedLimitListeners()
            self.setUpSelectedRoadListener()
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
    
    func setUpDrivingRecordListeners(){
        self.drivingRecordRef?.addSnapshotListener({(querySnapshot,error) in
            guard let querySnapshot = querySnapshot else{
                print("Error fetching documents")
                return
            }
            self.parseDrivingRecordSnaoshot(snapshot:querySnapshot)
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
    
    func parseDrivingRecordSnaoshot(snapshot:QuerySnapshot){
        snapshot.documentChanges.forEach({(change) in
            var parsedDrivingrecordDocument:DrivingRecordResponse?
            do{
                parsedDrivingrecordDocument = try change.document.data(as: DrivingRecordResponse.self)
            }catch{
                print("Unable to decode the Faicial infomation record")
                return
            }
            guard let drivingRecord = parsedDrivingrecordDocument else{
                print("Document does not exist")
                return
            }
            switch change.type{
            case .added:
                drivingRecordList.append(drivingRecord)
            default:
                ()
            }
        })
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType == .drivingRecord || listener.listenerType == .all {
                listener.onDrivingRecordChange(change: .add, drivingRecord: drivingRecordList)
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
    
    func addSelectedeRoad(_ record: UserSelectedRoadResponse) -> UserSelectedRoadResponse {
        var record = record
        do{
            if let selectedRoad = try selectedRoadRef?.addDocument(from: record){
                record.id = selectedRoad.documentID
            }
        }catch{
            print("Failed to serilise selected road record")
        }
        return record
    }

    func setUpSelectedRoadListener(){
        self.selectedRoadRef?.addSnapshotListener({(querySnapshot,error) in
            guard let querySnapshot = querySnapshot else{
                print("Error fetching road documents")
                return
            }
            self.parseSelectedRoadData(querySnapshot: querySnapshot)
        })
    }
    
    func parseSelectedRoadData(querySnapshot:QuerySnapshot){
        querySnapshot.documentChanges.forEach({(document) in
            var selectedRoadDocument:UserSelectedRoadResponse?
            do{
                selectedRoadDocument = try document.document.data(as: UserSelectedRoadResponse.self)
            }catch{
                print("Unable to decode the selected road document")
                return
            }
            guard let selectRoad = selectedRoadDocument else{
                print("Document does not exist")
                return
            }
            switch document.type{
            case .added:
                self.selectedRoadaList.append(selectRoad)
            case .modified,.removed:
                self.findIndexAndModifySpeedList(selectRoad,document.type)
            }
        })
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType == .selectedRoad || listener.listenerType == .all{
                listener.onSelectedRoadInfoChange(change: .add, selectRoads:selectedRoadaList)
            }
        })
    }
    
    func findIndexAndModifySpeedList(_ selectedRoad:UserSelectedRoadResponse, _ type:DocumentChangeType){
        guard let index = selectedRoadaList.firstIndex(where: {(road) in
            road.id == selectedRoad.id
        }) else {
            return
        }
        if type == .modified {
            selectedRoadaList[index] = selectedRoad
        }else if type == .removed{
            selectedRoadaList.remove(at: index)
        }
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)

        if listener.listenerType == .facial || listener.listenerType == .all{
            listener.onFacialInfoChange(change: .add, facialInfos: facialInfoList)
        }else if listener.listenerType == .selectedRoad || listener.listenerType == .all{
            listener.onSelectedRoadInfoChange(change: .add, selectRoads: selectedRoadaList)
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
    func addSelectedeRoad(_ record:UserSelectedRoadResponse)->UserSelectedRoadResponse
}
protocol DatabaseListener:AnyObject {
    var listenerType:ListenerType{get set}
    func onFacialInfoChange(change:DatabaseChange, facialInfos:[FacialInfo])
    func onSelectedRoadInfoChange(change:DatabaseChange, selectRoads:[UserSelectedRoadResponse])
    func onDrivingRecordChange(change:DatabaseChange, drivingRecord:[DrivingRecordResponse])
}

extension DatabaseListener{
    func onFacialInfoChange(change:DatabaseChange, facialInfos:[FacialInfo]){}
    func onSelectedRoadInfoChange(change:DatabaseChange, selectRoads:[UserSelectedRoadResponse]){}
    func onDrivingRecordChange(change:DatabaseChange, drivingRecord:[DrivingRecordResponse]){}
}

enum ListenerType {
    case facial
    case selectedRoad
    case drivingRecord
    case all
}
enum DatabaseChange {
    case add
    case remove
    case update
}
