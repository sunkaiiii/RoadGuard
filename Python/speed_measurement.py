import OBD2Helper
from firebase import FileStoreUserSelectedRoad
from firebase import FireStoreSaver
from gps_loader import GPSInformationExtractor
import threading
import mpu
import math
import requests
import cameraCapture
from firebase_admin import firestore
import time
import sys
from multiprocessing import Process
import os


gps_extractor = GPSInformationExtractor()

print(gps_extractor.get_current_position().latitude)
exitFlag = 0

# Key class for recording driving conditions
class SpeedRecordExtractor(threading.Thread):
    class Location:
        def __init__(self):
            self.latitude = 0.0
            self.longitude = 0.0
            
            
    def __init__(self,threadID,name,counter, document_id):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
        self.document_id = document_id
        self.current_place_id = ""
        self.current_speed_limit = -1
        self.location = self.Location()
        self.gps_info = gps_extractor.get_current_position()
        self.location.latitude = self.gps_info.latitude
        self.location.longitude = self.gps_info.longitude
        self.firebase = FileStoreUserSelectedRoad()
        # self._get_place_id_by_curent_place(self.location)
        print(self.location.latitude,",",self.location.longitude)
        self.running = False
        self.driving_distance = 0
        self.path = []

    #calculate distance between two coordinates, references on https://stackoverflow.com/questions/19412462/getting-distance-between-two-points-based-on-latitude-longitude/43211266#43211266
    def _calculate_distance(self,gps_info):
        R = 6373.0
        lat1 = math.radians(self.location.latitude)
        lon1 = math.radians(self.location.longitude)
        lat2 = math.radians(gps_info.latitude)
        lon2 = math.radians(gps_info.longitude)
        # dist = mpu.haversine_distance((lat1, lon1), (lat2, lon2))
        # print(dist*1000)
        # return dist*1000
        dlon = lon2 - lon1
        dlat = lat2 - lat1

        a = math.sin(dlat / 2)**2 + math.cos(lat1) * math.cos(lat2) * math.sin(dlon / 2)**2
        c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a))

        distance = R * c
        print("Distance: ",distance*1000)
        return distance*1000

    # 1.Every distance travelled (defined here as 80m) will be written to the firestore  
    # 2.While recording, find out if current is on a user-defined road section  
    # 3. If so, the person is captured and analysed
    # 4. If speeding is exceeded, a snap fen'xi is also taken.
    def run(self):
        while self.running:
            self.gps_info = gps_extractor.get_current_position()
            gps_info = self.gps_info
            print(gps_info)
            if gps_info.latitude != "Unknown" and gps_info.longitude != "Unknown":
                distance = self._calculate_distance(gps_info)
                if distance > 80:
                    self.driving_distance += distance
                    self.location.latitude = gps_info.latitude
                    self.location.longitude = gps_info.longitude
                    self.path.append({"latitude":gps_info.latitude,"longitude":gps_info.longitude})
                    # find selected road
                    place_ids = self._find_selected_raods(gps_info)

                    # save the current speed record
                    self._save_speed_record(gps_info,place_ids)
                    if len(place_ids) > 0:
                        speed = OBD2Helper.get_current_speed()
                        if speed == -sys.maxsize:
                            speed = gps_info.speed
                        # if over speed, capture a photo
                        cameraCapture.camera_capturing(gps_info,gps_info.speed,place_ids,self.document_id, self.current_speed_limit)


    # 1. get speed from OBD2
    # 2. if the OBD2 is not available, get the spped from the GPS
    def get_current_speed(self):
        speed = OBD2Helper.get_current_speed()
        if speed == -sys.maxsize:
            speed = self.gps_info.speed
        return speed


    def _find_selected_raods(self,gps_info):
        place_id = self._get_place_id_by_curent_place(gps_info)
        result = self.firebase.queryByPlaceId(place_id)
        placeIds = []
        if len(result) > 0:    
            for r in result:
                placeIds.append(r.id)
            print(placeIds)
        return placeIds

    # https://route.ls.hereapi.com/routing/7.2/calculateroute.json?jsonAttributes=1&waypoint0=-33.86349415655294,151.21035053629208&waypoint1=-33.8634928,151.21036909999998&legattributes=li&mode=fastest;car;&apiKey=
    def _find_limited_speed(self,lat1,log1,lat2,log2):
        api_key = "OA6INiK6jw1I5VxKkhGeaQUnvP_GyFu_Zp9R-Nl6oso"
        url = "https://route.ls.hereapi.com/routing/7.2/calculateroute.json?jsonAttributes=1&waypoint0={0},{1}&waypoint1={2},{3}&legattributes=li&mode=fastest;car;&apiKey={4}".format(lat1,log1,lat2,log2,api_key)
        try:
            print(url)
            r = requests.get(url)
            if r.status_code != 200:
                return -1
            response = r.json()
            print(response["response"]["route"][0]["leg"][0]["link"][0]["speedLimit"])
            return response["response"]["route"][0]["leg"][0]["link"][0]["speedLimit"]
        except:
            return -1
    
    def _save_speed_record(self,gps_info, place_ids = []):
        print("Prepare to save speed record")
        old_latitude = self.location.latitude
        old_longitude = self.location.longitude
        current_speed = OBD2Helper.get_current_speed()
        if current_speed == -sys.maxsize:
            print("obd2 is not working, extract with gps speed")
            current_speed = gps_info.speed
        print("Current speed is ",current_speed)
        self.limited_speed = self._find_limited_speed(old_latitude,old_longitude,self.location.latitude,self.location.longitude) * 3.6
        speed_record = {}
        speed_record["currentSpeed"] = current_speed
        speed_record["limitedSpeed"] = self.current_speed_limit
        speed_record["latitude"] = gps_info.latitude
        speed_record["longitude"] = gps_info.longitude
        speed_record["recordTime"] = firestore.SERVER_TIMESTAMP
        speed_record["recordId"] = self.document_id
        if len(place_ids) > 0:
            speed_record["selectedRoadIds"] = place_ids
        if self.limited_speed > 0:
            print("Current speed is:",current_speed,". Limited Speed is:",self.current_speed_limit )
            self.current_speed_limit = self.limited_speed
            if current_speed > self.current_speed_limit:
                print("You have overspeed, capture a image")
                doc_ref = cameraCapture.camera_capturing(location=gps_info,speed=current_speed,speed_limit = self.current_speed_limit,record_id = self.document_id)
                # capture a image
                speed_record["overSpeed"] = True
                speed_record["facialId"] = doc_ref.id
            else:
                speed_record["overSpeed"] = False
        saver = FireStoreSaver("speedLimitRecord")
        doc_ref = saver.save_to_firestore(speed_record)
        print("Successfully added speed record: ",doc_ref.id)

    # Network request using Python, references on https://www.datacamp.com/community/tutorials/making-http-requests-in-python
    def _get_place_id_by_curent_place(self,gps_info):
        request_url = "https://roads.googleapis.com/v1/nearestRoads?points=" + str.format("{0},{1}",gps_info.latitude,gps_info.longitude) + "&key=AIzaSyDiAamnK5z5Ohv4Lwu60TKcMzcaFsi0tTU"
        print("Request Nearest Road: ",request_url)
        r = requests.get(request_url)
        if r.status_code != 200:
            return ""
        response = r.json()
        print(len(response["snappedPoints"]))
        if len(response["snappedPoints"]) > 0:
            print(response["snappedPoints"][0]["placeId"])
            return response["snappedPoints"][0]["placeId"]
            
if __name__=="__main__":
    # gps = GPSInformationExtractor.GPSInformationResult()
    # gps.latitude = -37.9419905
    # gps.longitude = 145.12194
    # p = Process(target=cameraCapture.camera_capturing,args=(gps,45,["1"],"12312412123", 23))
    # p.start()
    thread = SpeedRecordExtractor(1,"SpeedRecordExtractorThread",1,"123")
    # thread.get_current_gps_speed()

    

    # print(thread._calculate_distance(gps))
    # place_ids = thread._find_selected_raods(gps)
    # thread._save_speed_record(gps,place_ids)
    thread.running = True
    thread.start()
    thread.join()
    # thread._find_limited_speed(-33.86349415655294,151.21035053629208,-33.8634928,151.21036909999998)
