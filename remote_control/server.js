var express = require('express')
var firebase = require("firebase");
var bodyParser = require('body-parser')
var request = require('request')
var os = require('os')
var app = express()

var ref = new Firebase("https://postmatesthing.firebaseio.com/")

// As an admin, the app has access to read and write all data, regardless of Security Rules
var db = firebase.database()
var ref = db.ref("restricted_access/secret_document") // TODO change to actual db
ref.once("value", function(snapshot) {
  console.log(snapshot.val())
})

app.set('port', (process.env.PORT || 5000))

// Process application/x-www-form-urlencoded
app.use(bodyParser.urlencoded({extended: false}))

// Process application/json
app.use(bodyParser.json())

// Index route
app.get('/', function (req, res) {
    res.send('Hello world, I am a chat bot')
})

// for Facebook verification
app.get('/webhook/', function (req, res) {
    if (req.query['hub.verify_token'] === 'my_voice_is_my_password_verify_me') {
        res.send(req.query['hub.challenge'])
    }
    res.send('Error, wrong token')
})

// Spin up the server
app.listen(app.get('port'), function() {
    console.log('running on port', app.get('port'))
})

app.post('/webhook/', function (req, res) {
    messaging_events = req.body.entry[0].messaging
    for (i = 0; i < messaging_events.length; i++) {
        event = req.body.entry[0].messaging[i]
        sender = event.sender.id
        if (event.message && event.message.text) {
          message = event.message.text
          messageLow = event.message.text.toLowerCase()
          if (messageLow == 'postback') {
            sendGenericMessage(sender)
            continue
          }
          if (messageLow == 'uptime') {
            var hostname = os.hostname()
            var uptime = formatUptime(process.uptime())
            sendTextMessage(sender, ':|] I am a bot named <@' + "same"+'>. I have been running for ' + uptime + ' on ' + hostname + '.')
            continue
          }
          if (messageLow == 'shutdown') {
            var commandRef = ref.child('command')
            commandRef.child(sender).set({
              value: "shutdown"
            })
          }
          if (messageLow == 'lock') {
            var commandRef = ref.child('command')
            commandRef.child(sender).set({
              value: "lock"
            })
          }
          if (getFirstWord(messageLow) == 'notification') {
            var notifRef = ref.child('notification')
            notifRef.child(sender).set({
              value: message.substring(message.indexOf(" ") + 1)
            })
          }
          sendTextMessage(sender, message.substring(0, 200))
            // firstWord = getFirstWord(event.message.text).toLowerCase()
            // if (firstWord === '@same') {
            //     text = event.message.text.substr(event.message.text.indexOf(" ") + 1)
            //     if (['uptime', 'identify yourself', 'who are you', 'what is your name', 'what is your name?'].indexOf(text.toLowerCase()) >= 0) {
            //       var hostname = os.hostname()
            //       var uptime = formatUptime(process.uptime())
            //       sendTextMessage(sender, ':|] I am a bot named <@' + "same"+'>. I have been running for ' + uptime + ' on ' + hostname + '.')
            //       continue
            //     }
            //     if (['same', ':|]', 'hi', 'hello', 'gn', 'goodnight', 'night', 'nite'].indexOf(text.toLowerCase()) >= 0) {
            //         sendTextMessage(sender, text.substring(0, 200))
            //         continue
            //     }
            //     if (text === 'dank') {
            //       sendTextMessage(sender, "memes")
            //       continue
            //     }
            //     sendTextMessage(sender, text.substring(0, 200) + ": not same")
            //     continue
            // }
            // else if (event.message.text === ':|]' || event.message.text.toLowerCase() === 'same') {
            //   sendTextMessage(sender, event.message.text.substring(0, 200))
            //   continue
            // }
        }
        if (event.postback) {
            text = JSON.stringify(event.postback)
            sendTextMessage(sender, "Postback received: "+text.substring(0, 200), token)
            continue
        }
    }
    res.sendStatus(200)
})
function sendTextMessage(sender, text) {
    messageData = {
        text:text
    }
    request({
        url: 'https://graph.facebook.com/v2.6/me/messages',
        qs: {access_token:token},
        method: 'POST',
        json: {
            recipient: {id:sender},
            message: messageData,
        }
    }, function(error, response, body) {
        if (error) {
            console.log('Error sending messages: ', error)
        } else if (response.body.error) {
            console.log('Error: ', response.body.error)
        }
    })
}

function sendImageMessage(sender, link) {
  if (link == "image") {
    messageData = {
      "attachment": {
          "type": "image",
          "payload": {
          "url":"https://i.ytimg.com/vi/xUhAxwBvSUM/maxresdefault.jpg"
        }
      }
    }
  }
  else {
    messageData = {
      "attachment": {
          "type": "image",
          "payload": {
          "url":link
        }
      }
    }
  }
  request({
      url: 'https://graph.facebook.com/v2.6/me/messages',
      qs: {access_token:token},
      method: 'POST',
      json: {
          recipient: {id:sender},
          message: messageData,
      }
  }, function(error, response, body) {
      if (error) {
          console.log('Error sending messages: ', error)
      } else if (response.body.error) {
          console.log('Error: ', response.body.error)
          sendImageMessage(sender, "image")
      }
  })
}

function sendGenericMessage(sender) {
    messageData = {
        "attachment": {
            "type": "template",
            "payload": {
                "template_type": "generic",
                "elements": [{
                    "title": "First card",
                    "subtitle": "Element #1 of an hscroll",
                    "image_url": "http://messengerdemo.parseapp.com/img/rift.png",
                    "buttons": [{
                        "type": "web_url",
                        "url": "https://www.messenger.com",
                        "title": "web url"
                    }, {
                        "type": "postback",
                        "title": "Postback",
                        "payload": "Payload for first element in a generic bubble",
                    }],
                }, {
                    "title": "Second card",
                    "subtitle": "Element #2 of an hscroll",
                    "image_url": "http://messengerdemo.parseapp.com/img/gearvr.png",
                    "buttons": [{
                        "type": "postback",
                        "title": "Postback",
                        "payload": "Payload for second element in a generic bubble",
                    }],
                }]
            }
        }
    }
    request({
        url: 'https://graph.facebook.com/v2.6/me/messages',
        qs: {access_token:token},
        method: 'POST',
        json: {
            recipient: {id:sender},
            message: messageData,
        }
    }, function(error, response, body) {
        if (error) {
            console.log('Error sending messages: ', error)
        } else if (response.body.error) {
            console.log('Error: ', response.body.error)
        }
    })
}

function formatUptime(uptime) {
    var unit = 'second';
    if (uptime > 60) {
        uptime = uptime / 60;
        unit = 'minute';
    }
    if (uptime > 60) {
        uptime = uptime / 60;
        unit = 'hour';
    }
    if (uptime != 1) {
        unit = unit + 's';
    }

    uptime = +uptime.toFixed(2) + ' ' + unit;
    return uptime;
}

function getFirstWord(str) {
        if (str.indexOf(' ') === -1)
            return str;
        else
            return str.substr(0, str.indexOf(' '));
}

var token = "CAAJyRJlBLqEBAOdjcrcnZBtfYuyuJFyvQqSADBbWFj8baZCpLTHbKbc6TAtYjJHX51QWuO3OlP48zmzzMa5NHkfJAmoZBKtVE5qsZBsqhpICTjnzxHZCYA7vTkGeDOrXFgrqv4RZCkD4T0o9pcgGMt8pfqeAH601PZATXspCgn4ZCiTcjchcvmYHYs6ImQcv4FIZD"
