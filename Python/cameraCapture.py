from picamera import PiCamera
from time import sleep
import datetime
import time
import os
import uploadImageToS3
from firebase import FireStoreSaver
from PIL import Image
from gps_loader import GPSInformationExtractor
import json
import OBD2Helper
bucket_name = "photo-collection-monash"
database_name = "FIT5140Ass3"
facial_collection = "facial"
gps_extractor = GPSInformationExtractor()

gps_info = gps_extractor.get_current_position()
def camera_capturing(location = None, speed = -1, selectedRoadIds = None, record_id = None, speed_limit = -1):
    if location is not None:
        gps_info = location
    else:
        gps_info = gps_extractor.get_current_position()
    if speed == -1:
        speed = OBD2Helper.get_current_speed()
    filename = str(datetime.datetime.utcnow()).replace(" ","_").replace(":","-").replace(".","-")+'.jpg'
    with PiCamera() as camera:
        camera.start_preview()
        camera.capture(filename)
    full_path = os.getcwd()+"/"+filename
    compress_image(full_path)
    doc_ref = analyse(full_path,speed,selectedRoadIds,record_id,speed_limit)
    return doc_ref

# compress captured image, references on https://sempioneer.com/python-for-seo/how-to-compress-images-in-python/
def compress_image(file_name):
    image = Image.open(file_name)
    image.save(file_name,quality=60,optimize=True)

def analyse(filename,speed = -1,selectedRoadIds = None,record_id = None,speed_limit = -1):
    print(filename)
    gps_information = gps_info
    uploadImageToS3.upload_image(filename,bucket_name)
    data = uploadImageToS3.detect_face(filename,bucket_name)
    data['location_info'] = {}
    data['location_info']["latitude"] = gps_information.latitude
    data['location_info']["longitude"] = gps_information.longitude
    data['speed'] = speed
    data['speedLiimt'] = speed_limit
    if selectedRoadIds != None:
        data['selectedRoadIds'] = selectedRoadIds
    if record_id != None:
        data['recordId'] = record_id
    saver = FireStoreSaver(facial_collection)
    doc_ref = saver.save_to_firestore(data)
    uploadImageToS3.delete_file(filename)
    return doc_ref

def start_sertvice():
    while(True):
        camera_capturing(selectedRoadIds= ["123","123"])
        sleep(2)

if __name__=="__main__":
    start_sertvice()
