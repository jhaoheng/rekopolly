import boto3

import sys 
sys.path.append('../') 
import config


# document : http://boto3.readthedocs.io/en/latest/reference/services/s3.html
# return
# ['bezos.jpg', 'cook.jpg', ...]

class s3Manager():
    """docstring for s3Manager"""
    def __init__(self):
        
        self.client = boto3.client(
                's3',
                aws_access_key_id = config.aws_access_key_id,
                aws_secret_access_key = config.aws_secret_access_key,
                # region_name = config.reko_region_name
            )

    def list_objects_v2(self):
        response = self.client.list_objects_v2(Bucket='orbweb-rekognition')

        s3FileName = [1] * len(response["Contents"])
        for index in range(len(response["Contents"])):
            s3FileName[index] = response["Contents"][index]['Key']
            pass
        return s3FileName

    def delete_objects(self, key):
        response = self.client.delete_objects(
            Bucket=config.bucket,
            Delete={
                'Objects': [
                    {
                        'Key': key,
                    },
                ]
            },
            )
        return response

    def get_object(self, key):
        response = self.client.get_object(
            Bucket=config.bucket,
            Key=key,
            )
        return response

    # Upload a file-like object to S3.
    # The file-like object must be in binary mode.
    def upload_fileobj(self, file, key):

        with open(file, 'rb') as data:
            response = self.client.upload_fileobj(
                Bucket=config.bucket,
                Fileobj=data,
                Key=key
                )
        return response


# example : 
# s3 = s3Manager()
# response = s3.list_objects_v2()
# response = s3.get_object("wells.jpg")
# response = s3.delete_objects("wells.jpg")
# response = s3.upload_fileobj("/Users/maxhu/Documents/orbweb/raspi-security-ipcam/dev/face_resources/Wells.jpg", "wells.jpg")
# print response


