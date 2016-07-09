########### Python 2.7 #############
import httplib, urllib, base64, ast, json
from time import sleep

headers = {
    # Request headers
    'Content-Type': 'application/octet-stream',
    'Ocp-Apim-Subscription-Key': '66085f1e7d544201a94c47c0ff9b8b46',
}

params = urllib.urlencode({
    # Request parameters
    'returnFaceId': 'true',
    'returnFaceLandmarks': 'false',
    'returnFaceAttributes': 'facialHair,glasses,gender'
})

for i in range (5791, 5828):
    with open("training_pictures/IMG_"+str(i)+".jpg", "rb") as f:
        data = f.read()
    try:
        conn = httplib.HTTPSConnection('api.projectoxford.ai')
        conn.request("POST", "/face/v1.0/detect?%s" % params, data, headers)
        response = conn.getresponse()
        data = response.read()
        data = ast.literal_eval(data)[0]
        print data
        conn.close()
    except Exception as e:
        print("[Errno {0}] {1}".format(e.error, e.strerror))

    with open('train.json', 'a') as outfile:
        json.dump(data, outfile)
    sleep(3)
