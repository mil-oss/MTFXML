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


var dbname = "mtfxml";
var viewLayout;
var msgid = null;
var setid = null;
var viewstate = "xml";
var xsltarget = "<?xml version='1.0' ?><xsd:schema xml:lang='en-US' xmlns:xsd='http://www.w3.org/2001/XMLSchema' elementFormDefault='unqualified' attributeFormDefault='unqualified'></xsd:schema>";
var nodeXSL = null;
var xmlViewXSLProc=null;
var msgRptXSL = null;
var setRptXSL = null;
var fieldRptXSL = null;
var currentNode;
var xmlser = new XMLSerializer();
var loadcount = 0;
var worklist = [];
var working = false;
$(document).ready(function () {
// OUTER-LAYOUT
    viewLayout = $('body').layout({
        west__size: 200, center__childOptions: {
            east__paneSelector: "#goeview", north__paneSelector: "#xmlhead", north__resizable: false, north__slidable: false, north__spacing_open: 0, east__size: .50, east__childOptions: {
                north__size: .25
            }
        },
        south__size: 40, south__resizable: false, south__slidable: false, south__spacing_open: 0
    });
    showLoadDialog("MTF XML Reference Application", "Initializing ...");
    setupProgressBars();
    window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB ||
            window.msIndexedDB;
    window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction ||
            window.msIDBTransaction;
    window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || window.msIDBKeyRange;
    if (!window.indexedDB) {
        alert("Sorry!Your browser doesn't support IndexedDB");
    }
});
var onSaxonLoad = function () {
    openDb(dbname, initDb);
};

function enableMenu() {
    //console.log("enableMenu");
    /*MenuLinks*/
    $("#fieldtree").accordion({
        collapsible: true,
        active: false
    });
    $(function () {
        $('p').mousedown(function () {
            $(this).addClass("waiting");
            $('p').css('background', 'white');
            $(this).css('background', 'yellow');
        });
    });
    $(function () {
        $('p').mouseup(function () {
            getNode(this);
        });
    });
    $("#waitdialog").dialog("close");
    $("#fieldtree div p").css("color", "black");
    getDataList('BaselineFields', function (res) {
        var pref = "#" + $(storekeys['BaselineFields'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineSets', function (res) {
        var pref = "#" + $(storekeys['BaselineSets'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineMessages', function (res) {
        var pref = "#" + $(storekeys['BaselineMessages'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineComposites', function (res) {
        var pref = "#" + $(storekeys['BaselineComposites'])[1];
        $(pref + res).css("color", "blue");
    });
}

function setupProgressBars() {
    //console.log("setupProgressBars");
    $("#bmsgcnt").text($(countcheck[ 'BaselineMessages'])[1]);
    $("#bsetcnt").text($(countcheck[ 'BaselineSets'])[1]);
    $("#bcompcnt").text($(countcheck[ 'BaselineComposites'])[1]);
    $("#bfieldcnt").text($(countcheck[ 'BaselineFields'])[1]);
    $("#gmsgcnt").text($(countcheck[ 'GoEMessages'])[1]);
    $("#gsegcnt").text($(countcheck[ 'GoESegments'])[1]);
    $("#gsetcnt").text($(countcheck[ 'GoESets'])[1]);
    $("#gfieldcnt").text($(countcheck[ 'GoEFields'])[1]);
}

function getNode(el) {
    var jel = $(el);
    var label = jel.text();
    var nodeId = jel.attr("id");
    xmlView();
    if (nodeXSL === null) {
        nodeXSL = Saxon.requestXML(dUrlList['NodeTreeHtm.xsl']);
        xmlViewXSLProc=Saxon.newXSLT20Processor(nodeXSL);
    }
    $("#xsdview").empty();
    $("#elementview").empty();
    $("#typeview").empty();
    loadcount = 0;
    console.log('nodeId: ' + nodeId);
    var section = jel.parent('div').prev('h3').text();
    if (section === 'Messages') {
        getNodeXsl('BaselineMessages', nodeId.substring(4), label, "#xsdview");
    } else if (section === 'Sets') {
        getNodeXsl('BaselineSets', nodeId.substring(4), label, "#xsdview");
    } else if (section === 'Composite Fields') {
        getNodeXsl('BaselineComposites', nodeId.substring(5), label, "#xsdview");
    } else if (section === 'Elemental Fields') {
        getNodeXsl('BaselineFields', nodeId.substring(6), label, "#xsdview");
    }
}

function getNodeXsl(dbstore, nodeId, label, target) {
    console.log("getNodeXsl:" + dbstore + " nodeId: " + nodeId);
    $("#rptviewbtn").hide();
    var tagname = nodeId.substring(nodeId.indexOf("_"));
    getRecord(dbstore, nodeId, function (resultobj) {
        if (typeof resultobj === "undefined") { //get node from source doc
            $.ajax({
                url: dUrlList[$(storekeys[dbstore])[0]],
                dataType: "xml",
                success: function (xsd) {
                    var node = $(xsd).children().children("[name='" + tagname + "']");
                    setIDs(dbstore, node);
                    var params = [['tagName', tagname]];
                    $(target).empty();
                    for (i = 0; i < params.length; i++) {
                        xmlViewXSLProc.setParameter(null, params[i][0], params[i][1]);
                    }
                    var result = xmlViewXSLProc.transformToFragment($(node)[0], document);
                    var vwstr = xmlser.serializeToString(result);
                    $(target).append(result);
                    var xobj = {
                        name: tagname,
                        storename: dbstore,
                        data: xmlser.serializeToString($(node)[0]),
                        xmlview: vwstr
                    };
                    currentNode = xobj;
                    addRecord(dbstore, currentNode, updateProgress);
                    loadcount++;
                    if (loadcount === 3) {
                        $('p').removeClass("waiting");
                        if (dbstore === "BaselineMessages") {
                            worklist.push(["BaselineMessages", tagname]);
                        }
                        if (dbstore === "BaselineSets") {
                            worklist.push(["BaselineSets", tagname]);
                        }
                    }
                },
                error: function (xhr, err, thrown) {
                    console.log("Failed to load " + $(storekeys[dbstore])[0] + " .. " + err.toString() + " .. " + thrown);
                }
            });
        } else {
            $(target).empty();
            $(target).append($.parseHTML(resultobj.xmlview));
            $("#reportview").empty();
            if (dbstore === "BaselineMessages" || dbstore === "BaselineSets") {
                currentNode = resultobj;
            }
            if (dbstore === "BaselineMessages" || dbstore === "BaselineSets" || dbstore === "GoEMessages" || dbstore === "GoESets") {
                if (worklist.indexOf(resultobj.name) !== -1) {
                    $("#rptviewbtn").show();
                }
            } else {
                $("#rptviewbtn").hide();
            }
            loadcount++;
            if (loadcount === 3) {
                $('p').removeClass("waiting");
            }
        }
    });
    var typeId = nodeId + "Type";
    if (dbstore === 'BaselineMessages') {
        getNodeXsl('GoEMessages', nodeId, label, "#elementview");
        getNodeXsl('GoEMessages', typeId, label, "#typeview");
    } else if (dbstore === 'BaselineSets') {
        getNodeXsl('GoESets', nodeId.substring(0, nodeId.length - 4), label, "#elementview");
        getNodeXsl('GoESets', typeId.substring(0, typeId.length - 4), label, "#typeview");
    } else if (dbstore === 'BaselineComposites') {
        if (nodeId === "MissionVerificationIndexType") {
            getNodeXsl('GoEFields', "MissionVerificationIndex", label, "#elementview");
            getNodeXsl('GoEFields', "MissionVerificationIndexComplexType", label, "#typeview");
        } else {
            var goecompelid = nodeId.substring(0, nodeId.length - 4);
            getNodeXsl('GoEFields', goecompelid, label, "#elementview");
            getNodeXsl('GoEFields', nodeId, label, "#typeview");
        }
    } else if (dbstore === 'BaselineFields') {
//Two complex types in baseline fields
        if (nodeId === "FreeTextType" || nodeId === "BlankSpaceCharacterType") {
            getNodeXsl('GoEFields', nodeId.substring(0, nodeId.length - 4), label, "#elementview");
            getNodeXsl('GoEFields', nodeId, label, "#typeview");
        } else {
            var goefieldid = nodeId.substring(0, nodeId.length - 4) + "SimpleType";
            var goefieldelid = nodeId.substring(0, nodeId.length - 4);
            getNodeXsl('GoEFields', goefieldelid, label, "#elementview");
            getNodeXsl('GoEFields', goefieldid, label, "#typeview");
        }
    }
}

function getMsgReport(msgid) {
    console.log("getMsgReport: " + msgid);
    getRecord("BaselineMessages", msgid, function (uimsgobj) {
        if (typeof uimsgobj !== "undefined") {
            var xmldom = Saxon.parseXML(uimsgobj.data);
            if (msgRptXSL === null) {
                msgRptXSL = Saxon.requestXML(dUrlList[ 'msgrpt.xsl']);
            }
            var params = [['setdocpath', dUrlList[ 'sets.xsd']]];
            var mrproc = Saxon.newXSLT20Processor(msgRptXSL);
            for (i = 0; i < params.length; i++) {
                mrproc.setParameter(null, params[i][0], params[i][1]);
            }
            var represult = mrproc.transformToFragment(xmldom, document);
            var mr = xmlser.serializeToString(represult);
            uimsgobj.report = mr;
            currentNode = uimsgobj;
            updateRecord(uimsgobj.storename, uimsgobj, updateProgress);
        } else {
            console.log("Failed to get message: " + msgid);
        }
    });
}

function getSetReport(setid) {
    console.log("getSetReport: " + setid);
    getRecord("BaselineSets", setid, function (uisetobj) {
        if (typeof uisetobj !== "undefined") {
            var xmldom = Saxon.parseXML(uisetobj.data);
            if (setRptXSL === null) {
                setRptXSL = Saxon.requestXML(dUrlList[ 'setrpt.xsl']);
            }
            var params = [['fieldsdocpath', dUrlList[ 'fields.xsd']], ['compositesdocpath', dUrlList[ 'composites.xsd']]];
            var sproc = Saxon.newXSLT20Processor(setRptXSL);
            for (i = 0; i < params.length; i++) {
                sproc.setParameter(null, params[i][0], params[i][1]);
            }
            var srepresult = sproc.transformToFragment(xmldom, document);
            var sr = xmlser.serializeToString(srepresult);
            uisetobj.report = sr;
            currentNode = uisetobj;
            updateRecord(uisetobj.storename, uisetobj, updateProgress);
        } else {
            console.log("Failed to get set: " + setid);
        }
    });
}

function setIDs(dbstore, node) {
    if (dbstore === "BaselineMessages") {
        $("#showview").show();
        msgid = $(node).find('MtfIdentifier').text();
        //console.log(msgid);
        setid = null;
    } else if (dbstore === "BaselineSets") {
        $("#showview").show();
        setid = $(node).find('SetFormatIdentifier').text();
        //console.log(setid);
        msgid = null;
    }
}

function clearDb() {
    console.log("clearDb");
    $("#infodialog").dialog("close");
    showLoadDialog("MTF XML Reference Application", "Initializing ...");
    deleteDB('mtfxml', function () {
        openDb(dbname, initDb);
    });
}

function clearDbDialog() {
    showDialog("RESET DATABASE", "This will delete all records and require reload.", clearDb);
}

function showLoadDialog(tit, msg) {
    //console.log('showWaitDialog');
    $("#waitdialog").children("p").text(msg);
    $("#waitdialog").dialog({
        dialogClass: "no-close",
        draggable: false,
        title: tit,
        modal: true
    });
}

function closeWaitDialog() {
    $("#waitdialog").dialog("close");
}

function showDialog(tit, msg, callback) {
    $("#dialog").children("p").text(msg);
    $("#dialog").dialog({
        dialogClass: "no-close",
        title: tit,
        modal: true,
        buttons: [{
                text: "Cancel",
                click: function () {
                    $(this).dialog("close");
                }
            }, {
                text: "OK",
                click: function () {
                    $(this).dialog("close");
                    if (typeof callback === "function") {
                        callback();
                    }
                }
            }]
    });
}

function tempDialog(tit, msg) {
    $("#dialog").children("p").text(msg);
    $("#dialog").dialog({
        dialogClass: "no-close",
        title: tit,
        modal: true,
        open: function () {
            setTimeout(function () {
                $("#dialog").dialog('close');
            }, 500);
        },
        buttons: [{
                text: "OK",
                click: function () {
                    $("#dialog").dialog("close");
                }
            }]
    });
}

function infoDialog() {
    $("#infodialog").dialog({
        dialogClass: "no-close",
        modal: true,
        draggable: false,
        height: 400,
        width: 500,
        buttons: [{
                text: "Close",
                click: function () {
                    $(this).dialog("close");
                }
            }]
    });
}

function reportView() {
    console.log('reportView');
    if (worklist[currentNode.name] === null) {
        alert("Report Generation Still Working - Try Later");
    } else {
        $("#rptviewbtn").hide();
        $("#xmlview").show();
        if (viewstate !== "report") {
            $("#goeview-toggler").click();
            $("#xmlhead-toggler").click();
            $("#goeview-toggler").hide();
        }
        $("#reportview").show();
        $("#xsdview").hide();
        viewstate = "report";
        $("#reportview").append($.parseHTML(currentNode.report));
    }
}

function xmlView() {
    console.log('xmlView');
    $("#rptviewbtn").show();
    $("#xmlview").hide();
    if (viewstate !== "xml") {
        $("#goeview-toggler").click();
        $("#xmlhead-toggler").click();
        $("#goeview-toggler").show();
    }
    $("#xsdview").show();
    $("#reportview").hide();
    viewstate = "xml";
}

function updateProgress(xobj) {
    //console.log('updateProgress: ' + xobj.storename + ' , ' + xobj.name);
    var progbarid = $(countcheck[xobj.storename])[0];
    $(progbarid).progressbar("option", "value", $(progbarid).progressbar("option", "value") + 1);
    if (xobj.storename === "BaselineMessages")
    {
        $("#msg_" + xobj.name).css('color', 'blue');
    } else if (xobj.storename === "BaselineSets")
    {
        $("#set_" + xobj.name).css('color', 'blue');
    } else if (xobj.storename === "BaselineComposites")
    {
        $("#comp_" + xobj.name).css('color', 'green');
    } else if (xobj.storename === "BaselineFields")
    {
        $("#field_" + xobj.name).css('color', 'green');
    }
}

function backgroundLoader() {
    getDataItems('BaselineMessages', 'report', function (name, res) {
        if (typeof res === "undefined") {
            worklist.push(['BaselineMessages', name]);
            doWork();
        } else {
            $("#msg_" + name).css('color', 'green');
        }
    });
    getDataItems('BaselineSets', 'report', function (name, res) {
        if (typeof res === "undefined") {
            worklist.push(['BaselineSets', name]);
            doWork();
        } else {
            $("#set_" + name).css('color', 'green');
        }
    });
}

function doWork() {
    console.log("doWork ");
    if (!working) {
        working = true;
        var rkeys = Object.keys(worklist);
        console.log(rkeys.length + " jobs");
        if (rkeys.length > 0) {
            var s = worklist[rkeys[0]][0];
            var n = worklist[rkeys[0]][1];
            console.log("Processing " + n + " message report from " + s);
            if (s === 'BaselineMessages') {
                //getMsgReport(n);
            } else {
                //getSetReport(n);
            }
        } else {
            working = false;
        }
    }
}

function updateWorkList(xobj) {
    consoleLog("updateWorkList .. Done Processing " + n + " message report from " + s);
    if (xobj.storename === "BaselineMessages")
    {
        $("#msg_" + xobj.name).css('color', 'green');
    } else if (xobj.storename === "BaselineSets")
    {
        $("#set_" + xobj.name).css('color', 'green');
    }
    var index = worklist.indexOf([xobj.storename, xobj.name]);
    alert(index);
    if (index > -1) {
        worklist.splice(index, 1);
    }
    doWork();
}