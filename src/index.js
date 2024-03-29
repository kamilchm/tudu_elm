'use strict';

require('font-awesome/css/font-awesome.css');
require('bulma/css/bulma.css');

// Require index.html so it gets copied to dist
require('./index.html');

import { load, add } from './storage'

var Elm = require('./Main.elm');
var mountNode = document.getElementById('main');

// .embed() can take an optional second argument. This would be an object describing the data we need to start a program, i.e. a userID or some token
var app = Elm.Main.embed(mountNode);

app.ports.pomoEnd.subscribe(function(msg) {
    var beep = document.getElementById("beep");
    beep.play()

    if ("Notification" in window) {
        if (Notification.permission === "granted") {
            var notification = new Notification(msg);
        }
        else if (Notification.permission !== 'denied') {
            Notification.requestPermission(function (permission) {
                if (permission === "granted") {
                    var notification = new Notification(msg);
                }
            });
        }
    }
});

app.ports.logError.subscribe(console.error);

app.ports.storePomodoro.subscribe(add);
load(app.ports.loadPomodoros.send);
