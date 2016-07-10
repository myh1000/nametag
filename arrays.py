import csv
import json, ast
# 0 michael 1 lilia 2 kevin
# 801 813
with open('train.json') as data_file:
    data = json.load(data_file)

with open('training.csv', 'w') as csvfile:
    trainCSV = csv.writer(csvfile, delimiter=',')
    trainCSV.writerow([len(data)])
    print len(data)
    for i in range (0,len(data)):
        attributes = data[i]['faceAttributes']
        face = attributes['facialHair']
        glasses = attributes['glasses']
        gender = attributes['gender']
        if gender == "male":
            gender = 0
        else:
            gender = 1
        if glasses == "NoGlasses":
            glasses = 0
        else:
            glasses = 1
        trainCSV = csv.writer(csvfile, delimiter=',')
        if (i <= 10):
            trainCSV.writerow([face['moustache'], face['beard'], face['sideburns'], glasses, gender, 0])
        elif (i <= 22):
            trainCSV.writerow([face['moustache'], face['beard'], face['sideburns'], glasses, gender, 1])
        else:
            trainCSV.writerow([face['moustache'], face['beard'], face['sideburns'], glasses, gender, 2])
