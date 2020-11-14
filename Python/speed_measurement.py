import OBD2Helper
from firebase import FileStoreUserSelectedRoad
from firebase import FireStoreSaver
from gps_loader import GPSInformationExtractor
import threading
import mpu
from math import sin, cos, sqrt, atan2, radians
import requests
import cameraCapture
from firebase_admin import firestore
import time

gps_extractor = GPSInformationExtractor()

print(gps_extractor.get_current_position().latitude)
exitFlag = 0
class SpeedRecordExtractor(threading.Thread):
    class Location:
        def __init__(self):
            self.latitude = 0.0
            self.longitude = 0.0
            
    def __init__(self,threadID,name,counter):
        threading.Thread.__init__(self)
        self.threadID = threadID
        self.name = name
        self.counter = counter
        self.current_place_id = ""
        self.current_speed_limit = -1
        self.location = self.Location()
        gps_info = gps_extractor.get_current_position()
        self.location.latitude = gps_info.latitude
        self.location.longitude = gps_info.longitude
        self.firebase = FileStoreUserSelectedRoad()
        # self._get_place_id_by_curent_place(self.location)
        print(self.location.latitude,",",self.location.longitude)
        self.running = True

    #calculate distance between two coordinates, references on https://stackoverflow.com/questions/19412462/getting-distance-between-two-points-based-on-latitude-longitude/43211266#43211266
    def _calculate_distance(self,gps_info):
        # R = 6373.0
        lat1 = radians(self.location.latitude)
        lon1 = radians(self.location.longitude)
        lat2 = radians(gps_info.latitude)
        lon2 = radians(gps_info.longitude)
        dist = mpu.haversine_distance((lat1, lon1), (lat2, lon2))
        print(dist*1000)
        return dist*1000
        # dlon = lon2 - lon1
        # dlat = lat2 - lat1

        # a = sin(dlat / 2)**2 + cos(lat1) * cos(lat2) * sin(dlon / 2)**2
        # c = 2 * atan2(sqrt(a), sqrt(1 - a))

        # distance = R * c

        # print("Result:", distance*1000)
    def run(self):
        while self.running:
            gps_info = gps_extractor.get_current_position()
            print(gps_info)
            if gps_info.latitude != "Unknown" and gps_info.longitude != "Unknown":
                distance = self._calculate_distance(gps_info)
                if distance > 300:
                    place_ids = self._find_selected_raods(gps_info)
                    self._save_speed_record(gps_info,place_ids)
                    if len(place_ids) > 0:
                        cameraCapture.camera_capturing(selectedRoadIds = place_ids)
            time.sleep(3)




    def _find_selected_raods(self,gps_info):
        place_id = self._get_place_id_by_curent_place(gps_info)
        result = self.firebase.queryByPlaceId(place_id)
        placeIds = []
        if len(result) > 0:    
            for r in result:
                placeIds.append(r.id)
            return placeIds

    # https://route.ls.hereapi.com/routing/7.2/calculateroute.json?jsonAttributes=1&waypoint0=-33.86349415655294,151.21035053629208&waypoint1=-33.8634928,151.21036909999998&legattributes=li&mode=fastest;car;&apiKey=
    def _find_limited_speed(self,lat1,log1,lat2,log2):
        api_key = "lhKFgFOIcw-WNlL9ykk3tzUUomMH1KCrFdzQD8Z4JBM"
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
        self.location.latitude = gps_info.latitude
        self.location.longitude = gps_info.longitude
        current_speed = OBD2Helper.get_current_speed()
        limited_speed = self._find_limited_speed(old_latitude,old_longitude,self.location.latitude,self.location.longitude)
        speed_record = {}
        speed_record["currentSpeed"] = current_speed
        speed_record["limitedSpeed"] = self.current_speed_limit
        speed_record["latitude"] = gps_info.latitude
        speed_record["longitude"] = gps_info.longitude
        speed_record["recordTime"] = firestore.SERVER_TIMESTAMP
        if len(place_ids) > 0:
            speed_record["selectedRoadIds"] = place_ids
        if limited_speed > 0:
            self.current_speed_limit = limited_speed
            if current_speed > self.current_speed_limit:
                doc_ref = cameraCapture.camera_capturing(location=gps_info,speed=current_speed)
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
    thread = SpeedRecordExtractor(1,"SpeedRecordExtractorThread",1)
    gps = GPSInformationExtractor.GPSInformationResult()
    gps.latitude = -37.91133603320601
    gps.longitude = 145.1223078707812
    place_ids = thread._find_selected_raods(gps)
    thread._save_speed_record(gps,place_ids)
    # thread.start()
    # thread._find_limited_speed(-33.86349415655294,151.21035053629208,-33.8634928,151.21036909999998)
