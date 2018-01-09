import boto3
import json
from PIL import Image

import sys 
sys.path.append('../') 
import config

# 1. detect_faces
# 2. get_confidence_highest

# faceFilePath : `./face_resources/bezos.jpg`
# response : { "FaceDetails":[], "ResponseMetadata":{}, "OrientationCorrection":""}
def detect_faces(faceFilePath):
    client = boto3.client(
        'rekognition',
        aws_access_key_id = config.aws_access_key_id,
        aws_secret_access_key = config.aws_secret_access_key,
        region_name = config.reko_region_name
    )
    p = open(faceFilePath, 'rb')
    face_features = client.detect_faces(Image={
       'Bytes':bytearray(p.read())
       }, Attributes=['ALL']
    )

    p.close()
    # print json.dumps(face_features)
    return face_features

# get highest confidence
def get_confidence_highest(face_features):
    # print json.dumps(face_features)
    max_confidence = 0
    index = 0
    for i in range(len(face_features["FaceDetails"])):
        confidence = face_features["FaceDetails"][i]['Confidence']
        if i == 0:
            max_confidence = confidence
            pass
        elif max_confidence<confidence:
            max_confidence=confidence
            index = i
            break
    # print face_features['FaceDetails'][0]['Confidence']
    # print json.dumps(face_features['FaceDetails'])
    # FaceDetails = face_features['FaceDetails']
    
    if max_confidence != 0:
        print(index, max_confidence)
        return face_features["FaceDetails"][index]
    return False

# cut img to highest confidence BoundingBox
def cutFromHighestConfidence(file, BoundingBox, savefile):
    im = Image.open( file )
    img_width, img_height = im.size

    # print img_width, img_height

    user_Width_rate = BoundingBox['Width']
    user_Height_rate = BoundingBox['Height']

    Top = BoundingBox['Top'] * img_height
    Left = BoundingBox['Left'] * img_width
    Right = Left + user_Width_rate*img_width
    Down = Top + user_Height_rate*img_height

    # print Top, Left, Right, Down

    # left, up, right, down
    nim = im.crop( ( int(Left), int(Top), int(Right), int(Down) ) )
    nim.save( savefile )
    pass

# [resource]
# bezos.jpg
# cook.jpg
# page.jpg
# trump.jpg
# zuck.jpg
# group1.jpg
# group2.jpg

# example : 
# file = './face_resources/group1.jpg'
# face_features = detect_faces(file)
# user = get_confidence_highest(face_features)
# cutFromHighestConfidence(file, user['BoundingBox'], "./tmp/detect_highest_confidence_user.jpg")




