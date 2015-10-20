/*
 * Copyright (C) 2015 jdn
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
/* global __dirname */

var express = require('express');
var compression = require('compression');
var url = require('url');
var request = require('request');
var fs = require('fs');
var xml2js = require('xml2js');
var http = require('http');
var app = express();
var bodyParser = require('body-parser');
app.use(bodyParser.json({
    limit: '100mb'
}));
app.use(bodyParser.urlencoded({
    limit: '100mb', extended: true
}));
app.use(express.static(__dirname + '/'));
app.use(compression());
app.get('/*', function (req, res) {
    res.sendFile(__dirname + '/app/' + req.url);
});
app.get('/json/*', function (req, res) {
    fs.stat(path, function (err, stats) {
        if (err === null) {
            res.sendFile(__dirname + '/' + req.url);
        } else {
            req.url
            xmlToJSon();
        }
    });
});
app.get('/xml/*', function (req, res) {
    res.sendFile(__dirname + '/' + req.url);
});
app.post('/json/*', function (req, res) {
    console.log("Post: " + __dirname + req.url);
    fs.writeFile(__dirname + req.url, JSON.stringify(req.body), function () {
        res.end();
    });
});
app.put('/json/*', function (req, res) {
    console.log("Put: " + __dirname + req.url);
    fs.writeFile(__dirname + req.url, JSON.stringify(req.body), function () {
        res.end();
    });
});
app.put('/xml/*', function (req, res) {
    console.log("Put " + req.url);
    //console.log(req.body);
    fs.writeFile(__dirname + '/json' + req.url, req.body, function () {
        res.end();
    });
});
app.put('/xmltojson/*', function (req, res) {
    console.log("Put: " + __dirname + '/json/' + req.name);
    var parser = new xml2js.Parser();
    parser.parseString(req.body, function (err, result) {
        fs.writeFile(__dirname + '/json/' + req.name, JSON.stringify(result));
        res.sendFile(__dirname + '/json/' + req.name);
    });
});
var server = http.createServer(app);
server.listen(8383, "0.0.0.0", function () {
    console.log('listening on 8383');
    loadData();
});

var res = [
    {'xml': '/xml/schema/USMTF/GoE_messages.xsd', 'json': '/json/GoE_messages.json'},
    {'xml': '/xml/schema/USMTF/GoE_segments.xsd', 'json': '/json/GoE_segments.json'},
    {'xml': '/xml/schema/USMTF/GoE_sets.xsd', 'json': '/json/GoE_sets.json'},
    {'xml': '/xml/schema/USMTF/GoE_fields.xsd', 'json': '/json/GoE_fields.json'},
    {'xml': '/xml/schema/NATOMTF/natomtf_goe_messages.xsd', 'json': '/json/natomtf_goe_messages.json'},
    {'xml': '/xml/schema/NATOMTF/natomtf_goe_segments.xsd', 'json': '/json/natomtf_goe_segments.json'},
    {'xml': '/xml/schema/NATOMTF/natomtf_goe_sets.xsd', 'json': '/json/natomtf_goe_sets.json'},
    {'xml': '/xml/schema/NATOMTF/natomtf_goe_fields.xsd', 'json': '/json/natomtf_goe_fields.json'}
];

var loadData = function () {
    console.log('syncData');
    for (i = 0; i < res.length; i++) {
        syncJsonFile(__dirname + res[i].xml, __dirname + res[i].json);
    }
};

var syncJsonFile = function (xmlpath, jsonpath) {
    fs.stat(xmlpath, function (xerr, xstats) {
        if (xerr === null) {
            var xd = new Date(xstats.mtime).getMilliseconds();
            fs.stat(jsonpath, function (jerr, jstats) {
                if (jerr === null) {
                    var jd = new Date(jstats.mtime).getMilliseconds();
                    if (xd > jd) {
                        console.log("Update: " + jsonpath);
                        xmlToJSon(xmlpath, jsonpath);
                    }
                } else if (jerr.code == 'ENOENT') {
                    console.log("Add: " + jsonpath);
                    xmlToJSon(xmlpath, jsonpath);
                }
            });
        } else if (xerr.code == 'ENOENT') {
            console.log(xmlpath + " not found.");
        }
    });
};

var xmlToJSon = function (path, jsonpath, res) {
    var parser = new xml2js.Parser();
    fs.readFile(path, function (err, data) {
        parser.parseString(data, function (err, result) {
            fs.writeFile(jsonpath, JSON.stringify(result), function () {
                if (res) {
                    res.sendFile(jsonpath);
                }
            });
        });
    });
};