import boto3
import json
import ntpath
import os

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
    print(response)
    return response