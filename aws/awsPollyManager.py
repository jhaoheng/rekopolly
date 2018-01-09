import boto3
import json
import os.path
import pygame
from botocore.exceptions import ClientError

import sys 
sys.path.append('../') 
import config

class pollyManager():
    def play_ogg(self, soundFile):
        # print soundFile
        try:
            pygame.mixer.pre_init()
            pygame.mixer.init()
            channelA = pygame.mixer.Channel(1)
            sounda = pygame.mixer.Sound(soundFile)
            channelA.set_volume(1.0)
            channelA.play(sounda)
            while channelA.get_busy():
                pygame.time.delay(100)
        except Exception as e:
            raise

    # get aws-polly stream with text
    def get_polly_stream(self, savePath, text):
        client = boto3.client(  
            'polly',
            aws_access_key_id = config.aws_access_key_id,
            aws_secret_access_key = config.aws_secret_access_key,
            region_name = config.polly_region_name
        )

        polly_response = client.synthesize_speech(  
            Text = text,
            OutputFormat = "ogg_vorbis",
            VoiceId = "Joanna")
        # print polly_response
        with open(savePath, 'wb') as f:  
            f.write(polly_response['AudioStream'].read())

# ex:
# polly = pollyManager()
# polly.get_polly_stream("Hello world")
# polly.play_ogg("polly_stream.ogg")



