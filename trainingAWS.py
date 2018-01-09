from aws.awsRekoIndexManager import indexManager
from aws.awsPollyManager import pollyManager
import sys 
import os.path
import json

def verifyImgPath(imgPath):
    try:
        imagePath = imgPath
    except Exception as e:
        print "err : argv[1] is empty"
        exit()

    if not imagePath.lower().endswith(('.jpg')):
        print "err : image file extension is not jpg"
        exit()
    elif not os.path.isfile(imagePath) :
        print "err : image path not exist"
        exit()

def forceExit():
    print "err : args empty"
    exit()
    pass

def help():
    print "\npython trainingAWS.py [command]"
    print "ex : python trainingAWS.py add $imgPath $imgName"
    print "[command]:"
    print "     clear       : "
    print "     add         : $imgPath $imgName"
    print "     list        : "
    print "     search      : $imgPath"
    print "     del         : $faceId"
    print "     playsound   : 'text'"
    exit()

argvs = sys.argv
try:
    cmd = str(argvs[1])
except Exception as e:
    help()



# main
if cmd == 'add':
    print "\ncmd : add ... \n"
    try:
        imagePath = argvs[2]
        imageName = argvs[3]
    except Exception as e:
        forceExit()
    verifyImgPath(imagePath)
    awsReko = indexManager()
    response = awsReko.addFace(imagePath, imageName)
    print json.dumps(response, indent=4, sort_keys=True)

elif cmd == 'clear':
    print "\ncmd : clear ... \n"
    awsReko = indexManager()
    response = awsReko.deleteCollection()
    response = awsReko.createCollection()
    print json.dumps(response, indent=4, sort_keys=True)


elif cmd == 'list':
    print "\ncmd : list ... \n"
    awsReko = indexManager()
    response = awsReko.listFace()
    print json.dumps(response, indent=4, sort_keys=True)

elif cmd == "search":
    print "\ncmd : search ... \n"
    try:
        imagePath = argvs[2]
    except Exception as e:
        forceExit()

    awsReko = indexManager()
    response = awsReko.search_faces_by_image(imagePath)
    print json.dumps(response, indent=4, sort_keys=True)

elif cmd == "del":
    print "\ncmd : del ... \n"
    try:
        faceId = argvs[2]
    except Exception as e:
        forceExit()

    faceIds = [faceId]
    print ("faceIds : %s")%(faceIds)
    awsReko = indexManager()
    response = awsReko.deleteFace(faceIds)
    print json.dumps(response, indent=4, sort_keys=True)

elif cmd == "playsound":
    print "\ncmd : playsound ... \n"
    try:
        text = argvs[2]
    except Exception as e:
        forceExit()

    polly = pollyManager()
    soundfile = os.getcwd() + "/tmp/test.ogg"
    polly.get_polly_stream(soundfile, text)
    polly.play_ogg(soundfile)
    os.remove(soundfile)

else:
    help()

