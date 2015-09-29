/* 
 * Copyright (C) 2015 JD NEUSHUL
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

var URL = window.URL || window.webkitURL;
var filesLoaded;
var dUrlList;

function initDb(list) {
    console.log("initDb stores:" + list.length);
    filesLoaded=0;
    dUrlList={};
    if (list.length === 0) {
        addDbStores(stores, function () {
            syncResources();
        });
    } else {
        syncResources();
    }
}

function syncResources() {
    console.log("syncResources");
    var rkeys = Object.keys(remoteurls);
    for (i = 0; i < rkeys.length; i++) {
        countRecords(rkeys[i], updateDataSrcs);
    }
    for (j = 0; j < xmlresources.length; j++) {
        updateResource(xmlresources[j]);
    }
}

function updateDataSrcs(dbstorename, recordcnt) {
    //console.log("updateDataSrcs " + dbstorename + " records: " + recordcnt);
    var rurl = base + remoteurls[dbstorename];
    var filename = $(storekeys[dbstorename])[0];
    var storecnt = $(countcheck[dbstorename])[1];
    var pbarid = $(countcheck[dbstorename])[0];
    var progressLabel = $(pbarid).children('div');
    $(pbarid).progressbar({
        max: $(countcheck[dbstorename])[1],
        value: recordcnt,
        change: function () {
            progressLabel.text($(pbarid).progressbar("value"));
        }, complete: function () {
            progressLabel.text("OK");
            $(pbarid).css("cursor", "default");
        }
    });
    //Check remote file header for availability or update
    $.ajax({
        type: "HEAD",
        url: rurl,
        cache: false,
        complete: function (XMLHttpRequest) {
            var hdrs = parseHeader(XMLHttpRequest);
            var etag = hdrs["etag"];
            var lastmod = hdrs["last-modified"];
            //console.log(filename + " src last-modified: " + lastmod);
            if (etag === null) {
                console.log("Remote file not found");
                if (storecnt !== recordcnt) {
                    progressLabel.text("No Data for " + dbstorename + " Available");
                }
            } else {//compare with local IndexedDb
                getRecord('Resources', filename, function (resultobj) {
                    if (typeof resultobj === "undefined") {//No file ref in local storage
                        console.log("No local data for: " + filename);
                        getXMLResource(etag, lastmod, rurl, "blob", function (resname, storedata) {
                            storedata.storename = dbstorename;
                            addRecord(resname, storedata, function (storedata) {
                                dUrlList[filename] = URL.createObjectURL(new Blob([storedata.data], {type: 'text/xml'}));
                                filesLoaded++;
                                checkComplete();
                            });
                        });
                    } else {//File found in local storage but out of date
                        if (resultobj.lastmod !== lastmod) {
                            console.log(filename + " found in local storage but out of date.");
                            getXMLResource(etag, lastmod, rurl, "blob", function (resname, storedata) {
                                storedata.storename = dbstorename;
                                updateRecord(resname, storedata, function (storedata) {
                                    dUrlList[filename] = URL.createObjectURL(new Blob([storedata.data], {type: 'text/xml'}));
                                    filesLoaded++;
                                    checkComplete();
                                });
                            });
                        } else if (recordcnt !== storecnt)
                        {//File found in local storage not processed completely
                            dUrlList[filename] = URL.createObjectURL(new Blob([resultobj.data], {type: 'text/xml'}));
                            filesLoaded++;
                            checkComplete();
                        } else if (recordcnt === storecnt) {
                            dUrlList[filename] = URL.createObjectURL(new Blob([resultobj.data], {type: 'text/xml'}));
                                filesLoaded++;
                                checkComplete();
                        }
                    }
                });
            }
        }
    });
}

function checkComplete() {
    if (filesLoaded === 9) {
        console.log("files loaded: " + filesLoaded);
        enableMenu();
    }
}

function updateResource(url) {
   // console.log("updateResource " + url);
    var filename = getFileName(url);
    $.ajax({
        type: "HEAD",
        url: url,
        cache: false,
        complete: function (XMLHttpRequest) {
            var headers = parseHeader(XMLHttpRequest);
            var etag = headers[ "etag"];
            var lastmod = headers[ "last-modified"];
            getRecord('Resources', filename, function (result) {
                if (typeof result === "undefined") {//No obj in local storage
                    if (etag !== null) {
                        getXMLResource(etag, lastmod, url, "xml", addRecord);
                        filesLoaded++;
                        checkComplete();
                    } else {
                        alert("Resource: " + filename + " Not Found");
                    }
                } else if (result.lastmod !== lastmod) {
                    console.log(filename+" MODIFIED " + lastmod + ",  prior time: " + result.lastmod);
                    getXMLResource(etag, lastmod, url, "xml", updateRecord);
                    filesLoaded++;
                    checkComplete();
                } else {
                    dUrlList[filename] = URL.createObjectURL(new Blob([result.data], {type: 'text/xml'}));
                    filesLoaded++;
                    checkComplete();
                }
            });
        }
    });
}

function getXMLResource(etag, lastmod, url, storetype, callback) {
    console.log("getResource " + url);
    var filename = getFileName(url);
    var xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
        if (this.readyState === 4 && this.status === 200) {
            console.log(filename + " retrieved");
            var newobj = {
                name: filename,
                etag: etag,
                url: url,
                lastmod: lastmod,
                data: this.response
            };
            dUrlList[filename] = URL.createObjectURL(new Blob([this.response], {type: 'text/xml'}));
            if (typeof callback === "function") {
                callback("Resources", newobj);
            }
        }
    };
    xhr.open("GET", url, true);
    xhr.responseType = storetype;
    xhr.send();
}

function parseHeader(XMLHttpRequest) {
    var h = XMLHttpRequest.getAllResponseHeaders().split("\n");
    var new_headers = {
    };
    for (var key = 0; key < h.length; key++) {
        if (h[key].length !== 0) {
            header = h[key].split(": ");
            new_headers[header[0].toLowerCase()] = header[1].toLowerCase();
        }
    }
    return new_headers;
}

function addElements(stname) {
    var filename = $(storekeys[stname])[0];
    console.log("addElements to" + stname);
    var storecnt = $(countcheck[stname])[1];
    var pbarid = $(countcheck[stname])[0];
    if ($(pbarid).progressbar("value") !== storecnt) {
        var xmlser = new XMLSerializer();
        getBlobXML("Resources", filename, function (xsd) {
            var globals = $(xsd).children().children();
            console.log("Elements Count: " + globals.length);
            for (j = 0; j < globals.length; j++) {
                var tag = $(globals[j]).prop("tagName");
                if (tag === "xsd:complexType" || tag === "xsd:simpleType" || tag === "xsd:element") {
                    var elnm = $(globals[j]).attr("name");
                    //Create link
                    //console.log("Element:" + elnm);
                    var xobj = {
                        name: elnm,
                        storename: stname,
                        data: xmlser.serializeToString(globals[j])
                    };
                    addRecord(stname, xobj, updateProgress);
                }
            }
        });
    } else {
        tempDialog("Load Element", "All Records Loaded for " + stname);
    }
}

function getFileName(url) {
    return url.substring(url.lastIndexOf('/') + 1);
}
