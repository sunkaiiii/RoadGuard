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
bucket_name = "photo-collection-monash"
database_name = "FIT5140Ass3"
facial_collection = "facial"
gps_extractor = GPSInformationExtractor()

def camera_capturing():
    filename = str(datetime.datetime.utcnow()).replace(" ","_").replace(":","-").replace(".","-")+'.jpg'
    with PiCamera() as camera:
        camera.start_preview()
        camera.capture(filename)
    full_path = os.getcwd()+"/"+filename
    compress_image(full_path)
    analyse(full_path)

# compress captured image, references on https://sempioneer.com/python-for-seo/how-to-compress-images-in-python/
def compress_image(file_name):
    image = Image.open(file_name)
    image.save(file_name,quality=60,optimize=True)

def analyse(filename):
    print(filename)
    gps_information = gps_extractor.get_current_position()
    uploadImageToS3.upload_image(filename,bucket_name)
    data = uploadImageToS3.detect_face(filename,bucket_name)
    data['location_info'] = json.dumps(gps_information)
    saver = FireStoreSaver(facial_collection)
    saver.save_to_firestore(data)
    uploadImageToS3.delete_file(filename)

def start_sertvice():
    while(True):
        camera_capturing()
        sleep(2)

if __name__=="__main__":
    start_sertvice()
