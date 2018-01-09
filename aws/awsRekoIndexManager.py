import boto3
import json
import os.path
from botocore.exceptions import ClientError

import sys 
sys.path.append('../') 
import config

class indexManager():
    """docstring for indexManager"""
    def __init__(self):
        # super(indexManager, self).__init__()

        self.client = boto3.client(
            'rekognition',
            aws_access_key_id = config.aws_access_key_id,
            aws_secret_access_key = config.aws_secret_access_key,
            region_name = config.reko_region_name
        )

    # delete collection
    def deleteCollection(self):
        try:
            response=self.client.delete_collection(
                CollectionId = config.CollectionId
                )
        except ClientError as e:
            # print e
            print e.response['Error']['Code']
            if e.response['Error']['Code']:
                response = ""
                pass
        return response
    
    # create collection
    def createCollection(self):
        try:
            response=self.client.create_collection(
                CollectionId = config.CollectionId
                )
        except ClientError as e:
            # print e
            print e.response['Error']['Code']
            if e.response['Error']['Code']:
                response = ""
                pass
        return response
        

    # create Image blob
    def setImageWithBinary(self, file):
        # ourceFile=open("face_resources/cook.jpg", "rb").read()
        return {'Bytes':open(file, "rb").read()}

    # create S3Object
    def setImageWithBucket(self, bucket, fileName):
        # SourceImage={'S3Object':{'Bucket':bucket,'Name':sourceFile}}
        return {'S3Object':{'Bucket':config.bucket, 'Name':fileName}}

    # add face to collection
    def addFace(self, inputImg, ExternalImageId):
        try:
            response=self.client.index_faces(
                CollectionId = config.CollectionId ,
                Image = self.setImageWithBinary(inputImg),
                # Image=self.setImageWithBucket(bucket, saveTargetImg),
                ExternalImageId = ExternalImageId,
                )
        except ClientError as e:
            print e
            print e.response['Error']['Code']
            if e.response['Error']['Code']:
                response = ""
                pass
        return response

    # list faces from collection
    def listFace(self):
        try:
            response=self.client.list_faces(
                CollectionId = config.CollectionId
                )
        except ClientError as e:
            # print e
            print e.response['Error']['Code']
            if e.response['Error']['Code']:
                response = ""
                pass
        return response

    # del faces from collection
    def deleteFace(self, FaceIds):
        try:
            response=self.client.delete_faces(
                CollectionId = config.CollectionId,
                FaceIds=FaceIds
                )
        except ClientError as e:
            # print e
            print e.response['Error']['Code']
            if e.response['Error']['Code']:
                response = ""
                pass
        return response

    # search faces by image from collection
    def search_faces_by_image(self, inputImg):
        try:
            response=self.client.search_faces_by_image(
                CollectionId = config.CollectionId ,
                FaceMatchThreshold = config.FaceMatchThreshold,
                Image = self.setImageWithBinary(inputImg)
                # Image=setImageWithBucket(bucket, saveTargetImg)
                )
        except ClientError as e:
            # print e
            print e.response['Error']['Code'] + " : " + inputImg
            if e.response['Error']['Code']:
                response = ""
                pass
        # print json.dumps(response)
        # print response["FaceMatches"][0]["Similarity"]
        return response

    # get ExternalImageId from `self.search_faces_by_image response`
    def get_FaceMatches_ExternalImageId(self, response):
        ExternalImageId = [1] * len(response['FaceMatches'])
        for index in range(len(response["FaceMatches"])):
            ExternalImageId[index] = response["FaceMatches"][index]['Face']['ExternalImageId']
        # print ExternalImageId
        return ExternalImageId

    # get Similarity from `self.search_faces_by_image response`
    def get_Face_score_orderby_Similarity(self, response):
        FaceMatches = response["FaceMatches"]
        print "----"
        for index in range(len(FaceMatches)):
            name = FaceMatches[index]['Face']['ExternalImageId']
            scoreSimilarity = FaceMatches[index]['Similarity']
            scoreConfidence = FaceMatches[index]['Face']['Confidence']
            print ("%s => [Similarity : %f, Confidence : %s]") % (name, scoreSimilarity, scoreConfidence)
        print "----"

# # ex:
# try:
#     imagePath = str(sys.argv[1])
# except Exception as e:
#     print "err : argv[1] is empty"
#     exit()
# if not imagePath.lower().endswith(('.jpg')):
#     print "err : image file extension is not jpg"
#     exit()
# elif not os.path.isfile(imagePath) :
#     print "err : image path not exist"
#     exit()

# test = indexManager()
# # response = test.search_faces_by_image(imagePath)
# # print json.dumps(response)
# # if not response:
# #     exit()
# #     pass
# # test.get_Face_score_orderby_Similarity(response)
# response = test.addFace(imagePath, "MAX")
# # response = test.listFace()
# # response = test.deleteFace(['5f2645eb-8358-46a2-ae5b-2e9572dbe5db'])
# print(response)


