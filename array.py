import csv
import json
data = json.load(something here)

with open('training.csv') as csvfile:
    trainCSV = csv.writer(csvfile, delimiter=',')
    trainCSV.writeRow([data.length])
    for row in data:
        trainCSV.writerow([some, data, here])
