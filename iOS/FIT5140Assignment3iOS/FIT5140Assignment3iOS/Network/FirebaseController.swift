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

///Controls all methods of interaction with the Firestore
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
            self.setUpFacialListeners()
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

    func setUpSpeedLimitListeners(){
        self.speedLimitRef?.addSnapshotListener({(querySnapshot,error) in
            guard let querySnapshot = querySnapshot else{
                print("Error fetching documents")
                return
            }
            self.parseSpeedLimitSnapshot(snapshot:querySnapshot)
        })
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

            var parsedFacialDocument:FacialInfo?
            do{
                //print(change.document.data())
                parsedFacialDocument = try change.document.data(as: FacialInfo.self)
                parsedFacialDocument?.id = change.document.documentID
            }catch{
                print(error)
                print("Unable to decode the Faicial infomation record")
                return
            }

            guard let facialInfo = parsedFacialDocument else{
                print("Document does not exist")
                return
            }

            switch change.type{
                case .added:
                    facialInfoList.append(facialInfo)
                default:
                    ()
            }
        })
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType.contains(.facial)  || listener.listenerType.contains(.all) {
                listener.onFacialInfoChange(change: .add, facialInfos: facialInfoList)
            }
        })
    }
    
    func parseDrivingRecordSnaoshot(snapshot:QuerySnapshot){
        snapshot.documentChanges.forEach({(change) in
            var parsedDrivingrecordDocument:DrivingRecordResponse?
            do{
                parsedDrivingrecordDocument = try change.document.data(as: DrivingRecordResponse.self)
                parsedDrivingrecordDocument?.id = change.document.documentID
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
        self.drivingRecordList.sort(by: {(r1,r2) in r1.startTime > r2.startTime})
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType.contains(.drivingRecord) || listener.listenerType.contains(.all) {
                listener.onDrivingRecordChange(change: .add, drivingRecord: drivingRecordList)
            }
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
        self.speedInforList.sort(by: {(s1,s2) in return s1.recordTime > s2.recordTime})
    }

    func parseSelectedRoadData(querySnapshot:QuerySnapshot){
        querySnapshot.documentChanges.forEach({(document) in
            var selectedRoadDocument:UserSelectedRoadResponse?
            do{
                selectedRoadDocument = try document.document.data(as: UserSelectedRoadResponse.self)
                selectedRoadDocument?.id = document.document.documentID
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
                    self.findIndexAndModifySelectedRoad(selectRoad,document.type)
            }
        })
        self.selectedRoadaList.sort(by: {(r1,r2) in return r1.createTime>r2.createTime})
        listeners.invoke(invocation: {(listener) in
            if listener.listenerType.contains(.selectedRoad) || listener.listenerType.contains(.all){
                listener.onSelectedRoadInfoChange(change: .add, selectRoads:selectedRoadaList)
            }
        })
    }

    func getSpeedRecordById(id:String)->Int?{
        return speedInforList.firstIndex(where: {(speed) in
            speed.id == id
        })
    }
    
    func getSpeedRecordByRecordId(_ recordId:String)->[SpeedRecord]{
        return speedInforList.filter({(speedInfo) in
            speedInfo.recordId == recordId && speedInfo.currentSpeed > 0
        })
    }
    
    func getFacialRecordByRecordId(_ recordId: String) -> [FacialInfo] {
        return facialInfoList.filter({(facial) in facial.recordId == recordId})
    }
    
    func getFacialRecordById(_ facialId: String) -> FacialInfo? {
        return facialInfoList.first(where: {(face) in face.id == facialId})
    }
    
    func getAllDrivingRecord() -> [DrivingRecordResponse] {
        return drivingRecordList
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
    
    func deleteSelectedRoadById(_ id: String) {
        selectedRoadRef?.document(id).delete()
    }

    func editSelectedRoad(_ id: String, points: [SnappedPointResponse]) -> UserSelectedRoadResponse? {
        guard let road = selectedRoadaList.first(where: {(r) in r.id == id}) else {
            return nil
        }
        return self.editSelectedRoad(id, points: points, customName: road.selectedRoadCustomName ?? "", storedUrl: road.userCustomImage ?? "")
    }

    
    func editSelectedRoad(_ id: String, points: [SnappedPointResponse], customName: String, storedUrl: String) -> UserSelectedRoadResponse? {
        guard var road = selectedRoadaList.first(where: {(r) in r.id == id}) else {
            return nil
        }
        road.selectedRoads = points
        road.placeIds = points.map({(points) in points.placeID})
        road.userCustomImage = storedUrl
        road.selectedRoadCustomName = customName
        do{
            try selectedRoadRef?.document(id).setData(from: road)
        }catch{
            print(error)
        }
        
        return road
    }
    
    func findIndexAndModifySelectedRoad(_ selectedRoad:UserSelectedRoadResponse, _ type:DocumentChangeType){
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

    // MARK: - Db Listner
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)

        if listener.listenerType.contains(.facial) || listener.listenerType.contains(.all){
            listener.onFacialInfoChange(change: .add, facialInfos: facialInfoList)
        }
        if listener.listenerType.contains(.selectedRoad) || listener.listenerType.contains(.all){
            listener.onSelectedRoadInfoChange(change: .add, selectRoads: selectedRoadaList)
        }
        if listener.listenerType.contains(.drivingRecord) || listener.listenerType.contains(.all){
            listener.onDrivingRecordChange(change: .add, drivingRecord: drivingRecordList)
        }
    }

    func removeListener(listener: DatabaseListener) {
        listeners.removeDelegate(listener)
    }
}

/**
 The implementation of this interface will be a must for data exchange with the programme
 # The data are combined in the following ways
 * The user can add the selectedRoad themselves, which will appear in FacialInfo
 * A FacialInfo contains information about the person as well as the location and, if the location is on a road selected by the user, the id of the SelectedRoad.
 * SpeedRecord is information about the speed, including current speed, position and speed limit.
 * DrivingRecord is a complete driving record. There may be several FacialInfo and several SpeedRecords within it, and therefore within both FacialInfo and SpeedRecord, the id of the corresponding DrivingRecord is stored
 *  The DrivingRecord's id can be used to get all its speedRecords as well as FacialInfo, and likewise a FacialInfo and speedRecord can be used to find the corresponding DrivingRecord.
*/
protocol DatabaseProtocol:NSObject {
    func addListener(listener: DatabaseListener)
    func removeListener(listener: DatabaseListener)
    func getSpeedRecordByRecordId(_ recordId:String)->[SpeedRecord]
    func getFacialRecordByRecordId(_ recordId:String)->[FacialInfo]
    func addSelectedeRoad(_ record:UserSelectedRoadResponse)->UserSelectedRoadResponse
    func getFacialRecordById(_ facialId:String)->FacialInfo?
    func deleteSelectedRoadById(_ id:String)
    func editSelectedRoad(_ id:String, points:[SnappedPointResponse]) -> UserSelectedRoadResponse?
    func editSelectedRoad(_ id:String, points:[SnappedPointResponse], customName:String,storedUrl:String)->UserSelectedRoadResponse?
    func getAllDrivingRecord()->[DrivingRecordResponse]
}

/**
 An object that implements this interface will be able to listen for changes to the data.
 ***
 The best practice for monitoring data changes is to implement this interface so that when data changes, it is simple to pass to a tableView to retrieve his UIView to update the view.
 */
protocol DatabaseListener:AnyObject {
    var listenerType:[ListenerType]{get set}
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
