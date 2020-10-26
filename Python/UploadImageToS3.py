import boto3
import json
import ntpath
import os

bucket_name = "photo-collection-monash"
# filename = '/home/pi/Documents/FIT5140_Assignment3/Python/20170527_172911.jpg'
def upload_image(file_name, bucket_name):
    s3 =boto3.resource('s3')

    data = open(file_name,'rb')
    s3.Bucket(bucket_name).put_object(Key=ntpath.basename(file_name),Body=data,ACL='public-read')
    data.close()
    
def delete_file(file_name):
    os.remove(file_name)

def detect_face(photo, bucket):
    photo = ntpath.basename(photo)
    client = boto3.client('rekognition')
    response = client.detect_faces(Image={'S3Object':{'Bucket':bucket,'Name':photo}},Attributes=['ALL'])
    print('Detected faces for ' + photo)    
    for faceDetail in response['FaceDetails']:
        print('The detected face is between ' + str(faceDetail['AgeRange']['Low']) 
              + ' and ' + str(faceDetail['AgeRange']['High']) + ' years old')
        print('Here are the other attributes:')
        print(json.dumps(faceDetail, indent=4, sort_keys=True))
    return len(response['FaceDetails'])

# upload_image(filename,bucket_name)
# detect_face(filename,bucket_name)
# delete_file(filename)
