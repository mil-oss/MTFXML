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
var nodeXSL = null;
var xmlViewXSLProc = null;
var msgRptXSL = null;
var setRptXSL = null;
var fieldRptXSL = null;
var currentNode;
var xmlser = new XMLSerializer();
var loadcount = 0;

$(document).ready(function () {
    // OUTER-LAYOUT
    viewLayout = $('body').layout({
        west__size: 200, 
        center__childOptions: {
            east__paneSelector: "#baselineview", 
            north__paneSelector: "#xmlhead", 
            north__resizable: false, 
            north__slidable: false, 
            north__spacing_open: 0, 
            east__size: .50, 
            east__childOptions: {
                north__size: .25,
                north__paneSelector: "#reportview"
            }
        },
        south__size: 40, south__resizable: false, south__slidable: false, south__spacing_open: 0
    });
    showLoadDialog("MTF XML Reference Application", "Loading XML Schemas ... ");
    /*setupProgressBars();*/
    window.indexedDB = window.indexedDB || window.mozIndexedDB || window.webkitIndexedDB ||
    window.msIndexedDB;
    window.IDBTransaction = window.IDBTransaction || window.webkitIDBTransaction ||
    window.msIDBTransaction;
    window.IDBKeyRange = window.IDBKeyRange || window.webkitIDBKeyRange || window.msIDBKeyRange;
    if (! window.indexedDB) {
        alert("Sorry!Your browser doesn't support IndexedDB");
    }
});

var onSaxonLoad = function () {
    openDb(dbname, initDb);
};

function enableMenu() {
    //console.log("enableMenu");
    /*MenuLinks*/
    $("#reportview-toggler").click();
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
        var pref = "#" + $(storekeys[ 'BaselineFields'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineSets', function (res) {
        var pref = "#" + $(storekeys[ 'BaselineSets'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineMessages', function (res) {
        var pref = "#" + $(storekeys[ 'BaselineMessages'])[1];
        $(pref + res).css("color", "blue");
    });
    getDataList('BaselineComposites', function (res) {
        var pref = "#" + $(storekeys[ 'BaselineComposites'])[1];
        $(pref + res).css("color", "blue");
    });
}

function getNode(el) {
    var jel = $(el);
    var label = jel.text();
    var nodeId = jel.attr("id");
    if (nodeXSL === null) {
        getRecord('Resources', 'NodeTreeHtm.xsl.lz', function (nodexsl) {
            var xsldoc = LZString.decompressFromUTF16(nodexsl.data);
            nodeXSL = $.parseXML(xsldoc);
            xmlViewXSLProc = Saxon.newXSLT20Processor(nodeXSL);
        });
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
    var tagname = nodeId.substring(nodeId.indexOf("_"));
    getRecord(dbstore, nodeId, function (resultobj) {
        if (typeof resultobj === "undefined") {
            //Get XSD Template
            getRecord("Resources", $(storekeys[dbstore])[2], function (xsdtemplateobj) {
                var xsdtemplate = LZString.decompressFromUTF16(xsdtemplateobj.data);
                //Get XSD
                getRecord("Resources", $(storekeys[dbstore])[0], function (xsdobj) {
                    var xsdstr = LZString.decompressFromUTF16(xsdobj.data);
                    var xsd = $.parseXML(xsdstr);
                    var node = $(xsd).children().children("[name='" + tagname + "']");
                    var elnode = $(xsd).children().children("[type='" + tagname + "']");
                    xsdtemplate = xsdtemplate.substring(0,xsdtemplate.length-14)+xmlser.serializeToString($(node)[0]);
                    if (elnode.length !== 0) {
                        xsdtemplate=xsdtemplate+xmlser.serializeToString($(elnode)[0]);
                    }
                    xsdtemplate=xsdtemplate+"</xsd:schema>";
                    var schemat = $.parseXML(xsdtemplate);
                    var params =[[ 'tagName', tagname]];
                    $(target).empty();
                    for (i = 0; i < params.length; i++) {
                        xmlViewXSLProc.setParameter(null, params[i][0], params[i][1]);
                    }
                    var result = xmlViewXSLProc.transformToFragment(schemat, document);
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
                    }
                });
            });
        } else {
            $(target).empty();
            $(target).append($.parseHTML(resultobj.xmlview));
            $("#reportview").empty();
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
        buttons:[ {
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
            },
            500);
        },
        buttons:[ {
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
        buttons:[ {
            text: "Close",
            click: function () {
                $(this).dialog("close");
            }
        }]
    });
}

function updateProgress(xobj) {
    //console.log('updateProgress: ' + xobj.storename + ' , ' + xobj.name);
    if (xobj.storename === "BaselineMessages") {
        $("#msg_" + xobj.name).css('color', 'green');
    } else if (xobj.storename === "BaselineSets") {
        $("#set_" + xobj.name).css('color', 'green');
    } else if (xobj.storename === "BaselineComposites") {
        $("#comp_" + xobj.name).css('color', 'green');
    } else if (xobj.storename === "BaselineFields") {
        $("#field_" + xobj.name).css('color', 'green');
    }
}