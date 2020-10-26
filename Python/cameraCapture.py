from picamera import PiCamera
from time import sleep
import datetime
import time
import os
import uploadImageToS3
from mongodb import MongodbSaver
bucket_name = "photo-collection-monash"
database_name = "FIT5140Ass3"
facial_collection = "facial"

def camera_capturing():
    filename = str(datetime.datetime.utcnow()).replace(" ","_").replace(":","-").replace(".","-")+'.jpg'
    with PiCamera() as camera:
        camera.start_preview()
        camera.capture(filename)
    full_path = os.getcwd()+"/"+filename
    analyse(full_path)

def analyse(filename):
    print(filename)
    uploadImageToS3.upload_image(filename,bucket_name)
    data = uploadImageToS3.detect_face(filename,bucket_name)
    saver = MongodbSaver(database_name,facial_collection)
    saver.save_to_mongodb(data)
    uploadImageToS3.delete_file(filename)

def start_sertvice():
    while(True):
        camera_capturing()
        sleep(5)

start_sertvice()