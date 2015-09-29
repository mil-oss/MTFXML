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

/*HTML 5 DATABASE*/
var dbRequest;
var dbVersion;
var dbName;
var Ldb;

//openDb
function openDb(name, callback) {
    console.log("openDb");
    dbName = name;
    dbRequest = indexedDB.open(dbName);
    dbRequest.onsuccess = function (evt) {
        Ldb = this.result;
        dbVersion = Ldb.version;
        console.log("openDb success, version: " + dbVersion);
        if (typeof callback === "function") {
            getStoreList(callback);
        }
    };
    dbRequest.onerror = function (e) {
        console.log('DB Error: Opened Database: ' + dbName + ',  Version: ' + dbversion + ' failed.');
    };
}

function getStoreList(callback) {
    //console.log("getStoreList");
    var storelist = [];
    var dataStores = Ldb.objectStoreNames;
    for (i = 0; i < dataStores.length; i++) {
        storelist.push(dataStores[i]);
    }
    if (typeof callback === "function") {
        callback(storelist);
    }
}

function getDataList(storename, callback) {
    //console.log('getDataList '+storename);
    var txn = Ldb.transaction([storename], "readonly");
    var objectStore = txn.objectStore(storename);
    objectStore.openCursor().onsuccess = function (event) {
        var cursor = event.target.result;
        if (cursor) {
            callback(cursor.value.name);
            cursor.continue();
        }
    };
}

function getDataItems(storename, index,callback) {
    //console.log('getDataList '+storename);
    var txn = Ldb.transaction([storename], "readonly");
    var objectStore = txn.objectStore(storename);
    objectStore.openCursor().onsuccess = function (event) {
        var cursor = event.target.result;
        if (cursor) {
            callback(cursor.value.name,cursor.value[index]);
            cursor.continue();
        }
    };
}

function countRecords(storename, callback) {
    Ldb.transaction([storename], "readonly").objectStore(storename).count().onsuccess = function (event) {
        if (typeof callback === "function") {
            callback(storename, event.target.result);
        }
    };
}
//addDbStores
//storename =storeschemas[i][0];
//storekey =storeschemas[i][1];
//storekeyincTF =storeschemas[i][2];
//indexname=storeschemas[i][3][j][0];
//indexref=storeschemas[i][3][j][1];
//indexuniqueTF=storeschemas[i][3][j][2];
function addDbStores(storeschemas, callback) {
    console.log("addDbStores");
    var storelist = [];
    dbVersion = Ldb.version + 1;
    dbName = Ldb.name;
    Ldb.close();
    Ldb = null;
    console.log("name: " + dbName + " version: " + dbVersion);
    dbRequest = indexedDB.open(dbName, dbVersion);
    dbRequest.onupgradeneeded = function (evt) {
        console.log("DB upgrade to version: " + dbVersion);
        var objectStore = null;
        Ldb = this.result;
        console.log("storeschemas.length: " + storeschemas.length);
        for (i = 0; i < storeschemas.length; i++) {
            storelist.push(storeschemas[i][0]);
            console.log("add store " + storeschemas[i][0] + " key:" + storeschemas[i][1] + " autoinc:" + storeschemas[i][2]);
            objectStore = Ldb.createObjectStore(storeschemas[i][0], {
                keyPath: storeschemas[i][1], autoIncrement: storeschemas[i][2]
            });
            var indices = storeschemas[i][3];
            for (j = 0; j < indices.length; j++)
            {
                console.log("add index " + indices[j][0] + " ref:" + indices[j][1] + " unique:" + indices[j][2]);
                objectStore.createIndex(indices[j][0], indices[j][1], {
                    unique: indices[j][2]
                });
            }
        }
    };
    dbRequest.onsuccess = function (evt) {
        console.log("Reopened Db version: " + dbVersion);
        Ldb = this.result;
        if (typeof callback === "function") {
            callback(storelist);
        }
    };
}
//clearDbStore
function clearDbStore(dbstorename, callback) {
    console.log("clearDbStore " + dbstorename);
    var tx = Ldb.transaction(dbstorename, "readwrite");
    var store = tx.objectStore(dbstorename);
    dbRequest = store.clear();
    dbRequest.onsuccess = function (evt) {
        dbcount = 0;
        console.log("Store cleared");
        if (typeof callback === "function") {
            callback(dbstorename);
        }
    };
}
//addRecord
function addRecord(dbstorename, dataobj, callback) {
    //console.log("addRecord " + dataobj.name+" in "+dbstorename);
    var trans = Ldb.transaction([dbstorename], "readwrite");
    var store = trans.objectStore(dbstorename);
    dbRequest = store.add(dataobj);
    trans.oncomplete = function (e) {
        //console.log("Record " + dataobj.name + " added to " + dbstorename);
        //alert(dataobj.data);
        if (typeof callback === "function") {
            callback(dataobj);
        }
    };
    dbRequest.onerror = function (e) {
        console.log("Record exists " + dataobj.name);
        if (typeof callback === "function") {
            callback(dataobj);
        }
    };
}
//updateRecord
function updateRecord(dbstorename, dataobj, callback) {
    //console.log("putRecord " + dataobj.name+" in "+dbstorename);
    var trans = Ldb.transaction([dbstorename], "readwrite");
    var store = trans.objectStore(dbstorename);
    dbRequest = store.put(dataobj);
    trans.oncomplete = function (e) {
        //console.log("Record " + dataobj.name + " added to " + dbstorename);
        if (typeof callback === "function") {
            callback(dataobj);
        }
    };
    dbRequest.onerror = function (e) {
        console.log("Add Record ERROR " + dataobj.name + " " + trans.error);
    };
}
//getRecord
function getRecord(dbstorename, key, callback) {
    //console.log("getRecord: " + key);
    var tx = Ldb.transaction(dbstorename, 'readonly');
    var store = tx.objectStore(dbstorename);
    dbRequest = store.get(key);
    dbRequest.onsuccess = function (evt) {
        if (typeof callback === "function") {
            callback(evt.target.result);
        } else {
            return(evt.target.result);
        }
    };
}
//getRecordValue
function getRecordValue(dbstorename, key, field, callback) {
    console.log("getRecordValue: " + key + " field: " + field);
    var tx = Ldb.transaction(dbstorename, 'readonly');
    var store = tx.objectStore(dbstorename);
    dbRequest = store.get(key);
    dbRequest.onsuccess = function (evt) {
        if (typeof callback === "function") {
            callback(evt.target.result[field]);
        } else {
            return(evt.target.result[field]);
        }
    };
}
//setRecordValue
function setRecordValue(dbstorename, key, field, value, callback) {
    console.log("setRecordValue " + key + " field: " + field);
    var tx = Ldb.transaction(dbstorename, 'readonly');
    var store = tx.objectStore(dbstorename);
    dbRequest = store.get(key);
    dbRequest.onsuccess = function (evt) {
        var dataobj = evt.target.result;
        dataobj[field] = value;
        putRecord(dbstorename, dataobj, callback);
    };
}
//deleteRecord
function deleteRecord(dbstorename, key, callback) {
    console.log("deleteRecord");
    var trans = Ldb.transaction([dbstorename], "readwrite");
    var store = trans.objectStore(dbstorename);
    dbRequest = store.get(key);
    dbRequest.onsuccess = function (evt) {
        var record = evt.target.result;
        console.log("Delete record:", record.name);
        if (typeof record === 'undefined') {
            console.log("No matching record found");
            return;
        }
        dbRequest = store.delete(key);
        dbRequest.onsuccess = function (evt) {
            console.log("Deletion successful");
            if (typeof callback === "function") {
                callback(dbstorename, key);
            }
        };
    };
}
//getRecordbyIndexValue
function getRecordbyIndexValue(dbstorename, fieldname, fieldvalue, callback) {
    console.log("getRecordbyFieldValue: " + fieldvalue);
    var trans = Ldb.transaction([dbstorename], "readonly");
    var store = trans.objectStore(dbstorename);
    var index = store.index(fieldname);
    dbRequest = index.get(fieldvalue);
    dbRequest.onsuccess = function (evt) {
        console.log("Record Found: " + new DOMParser().parseFromString(evt.target.result, "text/xml"));
        if (typeof callback === "function") {
            callback(evt.target.result);
        } else {
            return(dbstorename, evt.target.result);
        }
    };
}
//deleteRecordbyIndexValue
function deleteRecordbyIndexValue(dbstorename, fieldname, fieldvalue, callback) {
    console.log("deleteRecord");
    var trans = Ldb.transaction([dbstorename], "readwrite");
    var store = trans.objectStore(dbstorename);
    var index = store.index(fieldname);
    dbRequest = index.get(fieldvalue);
    dbRequest.onsuccess = function (evt) {
        var record = evt.target.result;
        console.log("Delete record:", record.name);
        if (typeof record === 'undefined') {
            console.log("No matching record found");
            return;
        }
        var key = record.key;
        dbRequest = store.delete(key);
        dbRequest.onsuccess = function (evt) {
            ;
            console.log("Deletion successful");
            if (typeof callback === "function") {
                callback(dbstorename, objlist);
            }
        };
    };
}
//deleteDB
function deleteDB(dbname, callback) {
    console.log("Delete " + dbname + " indexedDB");
    Ldb.close();
    var ddb = indexedDB.deleteDatabase(dbname);
    ddb.onsuccess = function () {
        console.log(dbname + " Deleted");
        if (typeof callback === "function") {
            callback();
        }
    };
     ddb.onerror = function (e) {
        console.log("Error deleting DB "+e);
        if (typeof callback === "function") {
            callback(dataobj);
        }
    };
}

function getBlobXML(dbstorename, key, callback) {
    console.log("getBlobXML: " + key);
    var tx = Ldb.transaction(dbstorename, 'readonly');
    var store = tx.objectStore(dbstorename);
    dbRequest = store.get(key);
    dbRequest.onsuccess = function (evt) {
        var dUrl = URL.createObjectURL(new Blob([evt.target.result.data], {type: 'text/xml'}));
        $.ajax({
            url: dUrl,
            dataType: "xml",
            success: function (xml) {
                if (typeof callback === "function") {
                    callback($(xml));
                } else {
                    return($(xml));
                }
            },
            error: function (xhr, err, thrown) {
                console.log("Failed to load " + filename + " .. " + err.toString() + " .. " + thrown);
            }
        });
    };
}