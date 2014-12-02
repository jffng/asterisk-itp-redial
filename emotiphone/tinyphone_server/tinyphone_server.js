var config = require("./config.json");

function setDefault(param, def){
    if (param === undefined){ return def; } else {return param;}
}

var enable_net_connections = setDefault(config.enable_net_connections, true);
var enable_web_connections = setDefault(config.enable_web_connections, true);
var enable_agi_connections = setDefault(config.enable_agi_connections, true);
var enable_sms_connections = setDefault(config.enable_sms_connections, true);
var AGI_HOST = setDefault(config.agi_host, '127.0.0.1');
var AGI_PORT = setDefault(config.agi_port, 12001);
var NET_PORT = setDefault(config.net_port, 12002);
var WEB_PORT = setDefault(config.web_port, 12003);
var SMS_PORT = setDefault(config.sms_port, 12004);
var SMS_RESPONSE = setDefault(config.sms_response, null);
var version = "1.0b4";
console.log(" _____ _                   _                      ");
console.log("/__   (_)_ __  _   _ _ __ | |__   ___  _ __   ___ ");
console.log("  / /\\/ | '_ \\| | | | '_ \\| '_ \\ / _ \\| '_ \\ / _ \\");
console.log(" / /  | | | | | |_| | |_) | | | | (_) | | | |  __/");
console.log(" \\/   |_|_| |_|\\__, | .__/|_| |_|\\___/|_| |_|\\___|");
console.log("              |___/|_|                            ");

console.log("Version " + version);

if (enable_agi_connections) {
    var agi_net = require('./connectors/tinyphone_agi.js');
    var agi = new agi_net.TinyphoneAGI();
    agi.on('agi_event', function(message, caller) {
        if (enable_net_connections) {
            tp_net.send(caller, message);
        }
        if (enable_web_connections) {
            tp_web.send(caller, message);
        }
        // console.log("caller: ", caller);
        console.log("message: ", message);
    });
    agi.start(AGI_HOST, AGI_PORT);
}

if (enable_net_connections) {
    var net_io = require('./connectors/tinyphone_net.js');
    var tp_net = new net_io.TinyphoneNet();
    tp_net.start(NET_PORT);
}

if (enable_web_connections) {
    var web_io = require('./connectors/tinyphone_web.js');
    var tp_web = new web_io.TinyphoneWeb();
    tp_web.start(WEB_PORT);
}

if (enable_sms_connections) {
    var sms_twilio = require("./connectors/tinyphone_twilio_sms.js");
    var sms = new sms_twilio.TinyphoneTwilioSMS();
    sms.on('sms_event', function(message, caller) {
        // console.log(JSON.stringify(message));
        // console.log(JSON.stringify(caller));
        if (enable_net_connections) {
            tp_net.send(caller, message);
        }
        if (enable_web_connections) {
            tp_web.send(caller, message);
        }
    });
    sms.start(SMS_PORT, SMS_RESPONSE);
}

