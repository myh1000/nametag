import csv
import json
# 0 michael 1 lilia 2 kevin
with open('test.json') as data_file:
    data = json.load(data_file)
print len(data)
with open('training.csv', 'a') as csvfile:
    trainCSV = csv.writer(csvfile, delimiter=',')
    trainCSV.writerow([len(data)])
    for i in range (0,len(data)):
        idx = str(i)
        attributes = data[idx]['faceAttributes']
        face = attributes['facialHair']
        glasses = attributes['glasses']
        if glasses == "":
            glasses = 0
        else:
            glasses = 1
        trainCSV = csv.writer(csvfile, delimiter=',')
        trainCSV.writerow([face['moustache'], face['beard'], face['sideburns'], glasses, 0])
