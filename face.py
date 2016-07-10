import tensorflow as tf
import numpy as np
import ast, json
from bottle import route, run, template, static_file, get, post, request

# Data sets
IRIS_TRAINING = "training.csv"
IRIS_TEST = "test.csv"

# Load datasets.
training_set = tf.contrib.learn.datasets.base.load_csv(filename=IRIS_TRAINING, target_dtype=np.int)
test_set = tf.contrib.learn.datasets.base.load_csv(filename=IRIS_TEST, target_dtype=np.int)

x_train, x_test, y_train, y_test = training_set.data, test_set.data, \
  training_set.target, test_set.target

# Build 3 layer DNN with 10, 20, 10 units respectively.
classifier = tf.contrib.learn.DNNClassifier(hidden_units=[10, 20, 10], n_classes=3)

# Fit model.
classifier.fit(x=x_train, y=y_train, steps=200)

# Evaluate accuracy.
accuracy_score = classifier.evaluate(x=x_test, y=y_test)["accuracy"]
print('Accuracy: {0:f}'.format(accuracy_score))

# Classify two new flower samples.
@route('/')
def index():
    return "same"

@post('/classify') # or @route('/login', method='POST')
def classify():
    message = request.forms.get('message')
    print message
    data = json.loads(message)
    print data
    attributes = data[0]['faceAttributes']
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
    array = np.array([face['moustache'], face['beard'], face['sideburns'], glasses, gender], dtype=float)
    y = classifier.predict(array)
    print ('Predictions: {}'.format(str(y)))
    return str(y)

run(host='localhost', port=8080)
