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
var url = require('url');
var fs = require('fs');
var lzstring = require('lz-string');
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
app.get('/*', function (req, res) {
    console.log(req.url);
    res.sendFile(__dirname + '/mtfapp/' + req.url);
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
    console.log("Put: " + __dirname + '/xml' +req.url);
    fs.writeFile(__dirname + '/xml' +req.url, JSON.stringify(req.body), function () {
        res.end();
    });
});
app.put('/xml/*', function (req, res) {
    console.log("Put "+ __dirname +req.url);
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
    syncData();
});
var res = [
    {'xml': '/xml/xsd/USMTF/GoE_messages.xsd', 'lz': '/xml/lz/usmtf_messages.xsd.lz'},
    {'xml': '/xml/xsd/USMTF/GoE_segments.xsd', 'lz': '/xml/lz/usmtf_segments.xsd.lz'},
    {'xml': '/xml/xsd/USMTF/GoE_sets.xsd', 'lz': '/xml/lz/usmtf_sets.xsd.lz'},
    {'xml': '/xml/xsd/USMTF/GoE_fields.xsd', 'lz': '/xml/lz/usmtf_fields.xsd.lz'},
    {'xml': '/xml/xsd/NATOMTF/natomtf_goe_messages.xsd', 'lz': '/xml/lz/nato_messages.xsd.lz'},
    {'xml': '/xml/xsd/NATOMTF/natomtf_goe_segments.xsd', 'lz': '/xml/lz/nato_segments.xsd.lz'},
    {'xml': '/xml/xsd/NATOMTF/natomtf_goe_sets.xsd', 'lz': '/xml/lz/nato_sets.xsd.lz'},
    {'xml': '/xml/xsd/NATOMTF/natomtf_goe_fields.xsd', 'lz': '/xml/lz/nato_fields.xsd.lz'},
    {'xml': '/xml/xml/usmtf_fields_ui.xml', 'lz': '/xml/lz/usmtf_fields_ui.xml.lz'},
    {'xml': '/xml/xml/usmtf_sets_ui.xml', 'lz': '/xml/lz/usmtf_sets_ui.xml.lz'},
    {'xml': '/xml/xml/usmtf_segments_ui.xml', 'lz': '/xml/lz/usmtf_segments_ui.xml.lz'},
    {'xml': '/xml/xml/usmtf_messages_ui.xml', 'lz': '/xml/lz/usmtf_messages_ui.xml.lz'},
    {'xml': '/xml/xml/nato_fields_ui.xml', 'lz': '/xml/lz/nato_fields_ui.xml.lz'},
    {'xml': '/xml/xml/nato_sets_ui.xml', 'lz': '/xml/lz/nato_sets_ui.xml.lz'},
    {'xml': '/xml/xml/nato_segments_ui.xml', 'lz': '/xml/lz/nato_segments_ui.xml.lz'},
    {'xml': '/xml/xml/nato_messages_ui.xml', 'lz': '/xml/lz/nato_messages_ui.xml.lz'}
];

var syncData = function () {
    console.log('syncData');
    for (i = 0; i < res.length; i++) {
        syncLZFile(__dirname + res[i].xml, __dirname + res[i].lz);
    }
};

var syncLZFile = function (xmlpath, lzpath) {
    fs.stat(xmlpath, function (xerr, xstats) {
        if (xerr === null) {
            var xd = new Date(xstats.mtime).getTime();
            fs.stat(lzpath, function (jerr, jstats) {
                if (jerr === null) {
                    var jd = new Date(jstats.mtime).getTime();
                    if (xd >jd) {
                        console.log("Update: " + lzpath);
                        compressXML(xmlpath, lzpath);
                    }
                } else if (jerr.code === 'ENOENT') {
                    console.log("Add: " + lzpath);
                    compressXML(xmlpath, lzpath);
                }
            });
        } else if (xerr.code === 'ENOENT') {
            console.log(xmlpath + " not found.");
        }
    });
};

var compressXML = function (path, lzpath) {
    fs.readFile(path, "utf-8", function (err, data) {
        if (err) {
            console.log("Error reading " + path);
        } else {
            var str = data;
            var compressed = lzstring.compressToUTF16(str);
            fs.writeFile(lzpath, compressed);
        }
    });
};
