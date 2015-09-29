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

function initDb(list) {
    console.log("initDb stores:" + list.length);
    filesLoaded = 0;
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
    $('#Init_prog').progressbar({
        max: compressedxmlresources.length,
        value: 0,
        complete: function () {
            $('#progMsg').text("All files loaded to cache");
        }
    });
/*    var rkeys = Object.keys(remoteurls);
    for (i = 0; i < rkeys.length; i++) {
        updateDataSrcs(rkeys[i]);
    }*/
    for (j = 0; j < compressedxmlresources.length; j++) {
        updateResource(compressedxmlresources[j]);
    }
}

/*function updateDataSrcs(dbstorename) {
    //console.log("updateDataSrcs " + dbstorename + " records: " + recordcnt);
    var rurl = remoteurls[dbstorename];
    var filename = $(storekeys[dbstorename])[0];
    //Check remote file header for availability or update
    $.ajax({
        type: "HEAD",
        url: rurl,
        cache: false,
        complete: function (XMLHttpRequest) {
            var etag = XMLHttpRequest.getResponseHeader ("ETag").toLowerCase();
            var lastmod = XMLHttpRequest.getResponseHeader ("Last-Modified").toLowerCase();
            //console.log(filename + " src last-modified: " + lastmod);
            if (etag === null) {
                console.log("Remote file not found");
            } else {
                //compare with local IndexedDb
                getRecord('Resources', filename, function (resultobj) {
                    if (typeof resultobj === "undefined") {
                        //No file ref in local storage
                        console.log("No local data for: " + filename);
                        getXMLResource(etag, lastmod, rurl, function (resname, storedata) {
                            storedata.storename = dbstorename;
                            addRecord(resname, storedata, function (storedata) {
                                checkComplete(filename);
                            });
                        });
                    } else {
                        //File found in local storage but out of date
                        if (resultobj.lastmod !== lastmod) {
                            console.log(filename + " found in local storage but out of date.");
                            getXMLResource(etag, lastmod, rurl, function (resname, storedata) {
                                storedata.storename = dbstorename;
                                updateRecord(resname, storedata, function (storedata) {
                                    checkComplete(filename);
                                });
                            });
                        } else {
                            checkComplete(filename);
                        }
                    }
                });
            }
        }
    });
}*/

function updateResource(url) {
    // console.log("updateResource " + url);
    var filename = getFileName(url);
    $.ajax({
        type: "HEAD",
        url: url,
        cache: false,
        complete: function (XMLHttpRequest) {
            var etag = XMLHttpRequest.getResponseHeader ("ETag").toLowerCase();
            var lastmod = XMLHttpRequest.getResponseHeader ("Last-Modified").toLowerCase();
            getRecord('Resources', filename, function (result) {
                if (typeof result === "undefined") {
                    //No obj in local storage
                    if (etag !== null) {
                        getXMLResource(etag, lastmod, url, addRecord);
                        checkComplete(filename);
                    } else {
                        alert("Resource: " + filename + " Not Found");
                    }
                } else if (result.lastmod !== lastmod) {
                    console.log(filename + " MODIFIED " + lastmod + ",  prior time: " + result.lastmod);
                    getXMLResource(etag, lastmod, url, updateRecord);
                    checkComplete(filename);
                } else {
                    checkComplete(filename);
                }
            });
        }
    });
}

function checkComplete(str) {
    filesLoaded++;
    //console.log("filesLoaded: " + filesLoaded+" of "+compressedxmlresources.length);
    $('#Init_prog').progressbar("option", "value", $('#Init_prog').progressbar("option", "value") + 1);
    $('#progMsg').append('<div>' + str + '</div>');
    if (filesLoaded === compressedxmlresources.length) {
        console.log("files loaded: " + filesLoaded);
        enableMenu();
        $('#progMsg').empty();
    }
}

function getXMLResource(etag, lastmod, url, callback) {
    console.log("getXMLResource " + url);
    var filename = getFileName(url);
    $.ajax({
        type: "GET",
        url: url,
        dataType: "text",
        success: function (str) {
            var newobj = {
                name: filename,
                etag: etag,
                url: url,
                lastmod: lastmod,
                data: str
            };
            if (typeof callback === "function") {
                callback("Resources", newobj);
            }
        },
        fail: function () {
            console.log("Could not retrieve file: " + rpath);
        }
    });
}

function getFileName(url) {
    return url.substring(url.lastIndexOf('/') + 1);
}

function compressData(rpath, tpath, callback) {
    console.log('compressResource: ' + rpath);
    $.ajax({
        type: "GET",
        url: rpath,
        dataType: "text",
        success: function (strdata) {
            var compressed = LZString.compressToUTF16(strdata);
            //console.log(compressed);
            $.ajax({
                type: "PUT",
                url: tpath,
                data: compressed,
                dataType: "text",
                success: function () {
                    console.log("Stored compressed: " + tpath);
                    callback(tpath);
                },
                fail: function () {
                    console.log("Could not store compressed: file: " + tpath);
                }
            });
        },
        fail: function () {
            console.log("Could not retrieve file: " + rpath);
        }
    });
}

function decompressData(rpath, callback) {
    console.log('decompressResource: ' + rpath);
    $.ajax({
        type: "GET",
        url: rpath,
        dataType: "text",
        success: function (strdata) {
            var str = LZString.decompressFromUTF16(strdata);
            callback(str);
        },
        fail: function () {
            console.log("Could not retrieve file: " + rpath);
        }
    });
}