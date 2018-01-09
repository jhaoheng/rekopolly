import boto3
import json
import base64

import sys 
sys.path.append('../') 
import config

# faceFilePath : `./face_resources/bezos.jpg`
# response : 
# {
#   "FaceMatches":[], 
#   "SourceImageFace":{}, 
#   "SourceImageOrientationCorrection":"", 
#   "TargetImageOrientationCorrection":"", 
#   "UnmatchedFaces":[]
# }

def setImageWithBinary(filePath):
    # ourceFile=open("face_resources/cook.jpg", "rb").read()
    return {'Bytes':open(filePath, "rb").read()}

def setImageWithBucket(bucket, fileName):
    # SourceImage={'S3Object':{'Bucket':bucket,'Name':sourceFile}}
    return {'S3Object':{'Bucket':bucket,'Name':fileName}}

def face_compare(inputImg, saveTargetImg):
    bucket='orbweb-rekognition'
    client = boto3.client(
        'rekognition',
        aws_access_key_id = config.aws_access_key_id,
        aws_secret_access_key = config.aws_secret_access_key,
        region_name = config.reko_region_name
    )
    response=client.compare_faces(
        SimilarityThreshold=90,
        SourceImage=setImageWithBinary(inputImg),
        # TargetImage=setImageWithBinary("face_resources/cook.jpg")
        # SourceImage=setImageWithBucket(bucket, "cook.jpg"),
        TargetImage=setImageWithBucket(bucket, saveTargetImg)
        )

    # print json.dumps(response)
    for faceMatch in response['FaceMatches']:
        position = faceMatch['Face']['BoundingBox']
        confidence = str(faceMatch['Face']['Confidence'])
        saveName = (saveTargetImg.split("."))[0]
        # print("Match : "+saveName)
        return True, saveName
    return False, ""
        # print('The face at ' +
        #        str(position['Left']) + ' ' +
        #        str(position['Top']) +
        #        ' matches with ' + confidence + '% confidence')
 
# [resource]
# bezos.jpg
# cook.jpg
# page.jpg
# trump.jpg
# zuck.jpg
# group1.jpg
# group2.jpg
    
# example : 
# if __name__ == "__main__":
#     inputImg = "face_resources/cook.jpg"
#     saveTargetImg = "cook.jpg"
#     is_success, name = face_compare(inputImg, saveTargetImg)
#     if is_success:
#         print("Match : "+name)
#         pass







