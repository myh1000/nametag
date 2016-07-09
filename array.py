import csv
import json

with open('test.json') as data_file:
    data = json.load(data_file)
print len(data)
attributes = data['faceAttributes']
face = attributes['facialHair']
glasses = attributes['glasses']
if glasses == "":
    glasses = 0
else:
    glasses = 1


with open('training.csv', 'w') as csvfile:
    trainCSV = csv.writer(csvfile, delimiter=',')
    trainCSV.writerow([len(attributes)])
    for row in data:
        trainCSV.writerow([face['moustache'], face['beard'], face['sideburns'], glasses, person])
