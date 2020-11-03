import boto3
import json
import ntpath
import os
import time
from firebase_admin import firestore

bucket_name = "photo-collection-monash"


def upload_image(file_name, bucket_name):
    s3 =boto3.resource('s3')
    data = open(file_name,'rb')
    s3.Bucket(bucket_name).put_object(Key=ntpath.basename(file_name),Body=data, ACL='public-read')
    data.close()
    
def delete_file(file_name):
    os.remove(file_name)

def detect_face(photo, bucket):
    photo = ntpath.basename(photo)
    client = boto3.client('rekognition')
    response = client.detect_faces(Image={'S3Object':{'Bucket':bucket,'Name':photo}},Attributes=['ALL'])
    response["ImageUrl"] = "https://"+bucket_name+".s3.amazonaws.com/"+photo
    response["CapturedTime"] = firestore.SERVER_TIMESTAMP
    del response["ResponseMetadata"]
    response = _simplify_json(response)
    print(response)
    return response


def _simplify_json(json_response):
    face_details = json_response["FaceDetails"]
    for face in face_details:
        filer_keys = []
        for key in face.keys():
            if key != "Emotions" and key != "Pose":
                filer_keys.append(key)
        for key in filer_keys:
            del face[key]
        filer_keys = []

    json_response["FaceDetails"] = face_details
    print(json_response)
    return json_response

if __name__=="__main__":
    json_file = json.load(open("/home/pi/Documents/FIT5140_Assignment3/Python/testjson.json"))
    _simplify_json(json_file)