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
var viewXSD = null;
var msgXSD = null;
var setsXSD = null;
var compXSD = null;
var fieldsXSD = null;
var msgDOC = null;
var setsDOC = null;
var compDOC = null;
var fieldsDOC = null;
var viewXSDProc = null;
var msgDOCProc = null;
var xmlser = new XMLSerializer();
var loadcount = 0;

$(document).ready(function () {
    // OUTER-LAYOUT
    doLayout();
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

function doLayout() {
    viewLayout = $('body').layout({
        west__size: 200,
        center__childOptions: {
            north__paneSelector: "#xmlhead",
            north__resizable: false,
            north__slidable: false,
            north__spacing_open: 0,
            west__paneSelector: "#xsdview",
            west__size: .33,
            west__childOptions: {
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0,
                center__size: .5,
                center__childOptions: {
                    north__size: .5,
                    north__paneSelector: "#msgxsd",
                    center__size: .5,
                    center__paneSelector: "#setsxsd"
                },
                south__size: .5,
                south__childOptions: {
                    north__size: .5,
                    north__paneSelector: "#compsxsd",
                    center__size: .5,
                    center__paneSelector: "#fieldsxsd"
                }
            },
            center__paneSelector: "#docsview",
            center__size: .33,
            center__childOptions: {
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0
            },
            east__paneSelector: "#formview",
            east__size: .33,
            east__childOptions: {
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0
            }
        },
        south__size: 40, south__resizable: false, south__slidable: false, south__spacing_open: 0
    });
}

var onSaxonLoad = function () {
    openDb(dbname, initDb);
};

function enableMenu() {
    console.log("enableMenu");
    /*MenuLinks*/
    $("#fieldtree").accordion({
        collapsible: true,
        active: false
    });
    $(function () {
        $('p').mousedown(function () {
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
    getDataList('GoEMessages', function (res) {
        $("#" + res).css("color", "green");
    });
}

function getNode(el) {
    console.log("getNode");
    showLoadDialog("MTF Documents","Loading ....");
    var jel = $(el);
    var label = jel.text();
    var nodeId = jel.attr("id");
    $("#sidebar").addClass("waiting");
    $("#msgxsd").empty();
    $("#msgxsd").addClass("waiting");
    $("#setsxsd").empty();
    $("#setsxsd").addClass("waiting");
    $("#compsxsd").empty();
    $("#compsxsd").addClass("waiting");
    $("#fieldsxsd").empty();
    $("#fieldsxsd").addClass("waiting");
    $("#msgdoc").empty();
    $("#msgdoc").addClass("waiting");
    $("#msgfrm").empty();
    $("#msgfrm").addClass("waiting");
    if (viewXSD === null) {
        getRecord("Resources", "NodeTreeHtm.xsl.lz", function (vxsl) {
            viewXSD = Saxon.parseXML(LZString.decompressFromUTF16(vxsl.data));
            viewXSDProc = Saxon.newXSLT20Processor(viewXSD);
            getRecord("Resources", "GoE_Msg_Doc.xsl.lz", function (dxsl) {
                msgDOC = Saxon.parseXML(LZString.decompressFromUTF16(dxsl.data));
                msgDOCProc = Saxon.newXSLT20Processor(msgDOC);
                msgDOCProc.setInitialTemplate("makeMsgDoc");
                getSchema("GoEMessages", nodeId, label);
                getSchema("GoESets", nodeId, "SETS");
                getSchema("GoEComposites", nodeId, "COMPOSITES");
                getSchema("GoEFields", nodeId, "FIELDS", getMsgDoc);
            });
        });
    } else {
        getSchema("GoEMessages", nodeId, label);
        getSchema("GoESets", nodeId, "SETS");
        getSchema("GoEComposites", nodeId, "COMPOSITES");
        getSchema("GoEFields", nodeId, "FIELDS", getMsgDoc);
    }
}

function getSchema(store, nodeId, label, callback) {
    console.log("getMsgSchemas " + store + ": " + nodeId);
    var suf = $(storekeys[store])[1];
    var tdiv = $(storekeys[store])[2]
    getRecord(store, nodeId, function (msgobj) {
        if (typeof msgobj === "undefined") {
            console.log("load remote ..");
            $.ajax({
                type: "GET",
                url: schemaroot + nodeId + '/' + nodeId + suf,
                dataType: "text",
                success: function (str) {
                    var xsdstr = LZString.decompressFromUTF16(str);
                    xsd = Saxon.parseXML(xsdstr);
                    viewXSDProc.setParameter(null, 'tagName', label);
                    var xsdvw = viewXSDProc.transformToFragment(xsd, document);
                    var vwstr = xmlser.serializeToString(xsdvw);
                    $(tdiv).append(vwstr);
                    var compview = LZString.compressToUTF16(vwstr);
                    var mobj = {
                        name: nodeId,
                        storename: store,
                        data: str,
                        xmlview: compview
                    }
                    addRecord(store, mobj, function () {
                        $("#" + nodeId).css('color', 'green');
                        $(tdiv).removeClass("waiting");
                        if (typeof callback === "function") {
                            callback(nodeId);
                        }
                    });
                    return (xsd);
                },
                fail: function () {
                    console.log("Could not retrieve file: " + rpath);
                }
            });
        } else {
            var vw = LZString.decompressFromUTF16(msgobj.xmlview);
            $(tdiv).append(vw);
            $(tdiv).removeClass("waiting");
            if (typeof callback === "function") {
                callback(nodeId);
            }
        }
    });
}

function getMsgDoc(nodeId) {
    console.log("getMsgDoc");
    getRecord("GoEMessages", nodeId, function (msgobj) {
        if (typeof msgobj === "undefined") {
            console.log("No data..");
        } else if (typeof msgobj.xmldoc === "undefined") {
            loadDoc(nodeId, msgobj);
        } else {
            var docstr = LZString.decompressFromUTF16(msgobj.xmldoc);
            var msgdoc = $.parseHTML(docstr);
            $("#msgdoc").append(msgdoc);
            $("#msgdoc").removeClass("waiting");
            console.log("Doc Loaded..");
            getMsgFrm(nodeId);
        }
    });
}

function loadDoc(nodeId, msgobj) {
    $.ajax({
        type: "GET",
        url: schemaroot + nodeId + '/' + nodeId + "_Doc.html.lz",
        dataType: "text",
        success: function (htmstr) {
            var docstr = LZString.decompressFromUTF16(htmstr);
            var msgdoc = $.parseHTML(docstr);
            $("#msgdoc").append(msgdoc);
            var mobj = {
                name: nodeId,
                storename: "GoEMessages",
                data: msgobj.data,
                xmlview: msgobj.xmlview,
                xmldoc: htmstr
            };
            updateRecord("GoEMessages", mobj, function () {
                $("#" + nodeId).css('color', 'green');
                $("#msgdoc").removeClass("waiting");
                console.log("Doc Loaded..");
                 getMsgFrm(nodeId);
            });
        },
        fail: function () {
            console.log("Could not retrieve file: " + rpath);
        }
    });
}

function getMsgFrm(nodeId) {
    console.log("getMsgFrm");
    getRecord("GoEMessages", nodeId, function (msgobj) {
        if (typeof msgobj === "undefined") {
            console.log("No data..");
        } else if (typeof msgobj.xmlfrm === "undefined") {
            loadFrm(nodeId, msgobj);
        } else {
            var frmstr = LZString.decompressFromUTF16(msgobj.xmlfrm);
            var msgfrm = $.parseHTML(frmstr);
            $("#msgfrm").append(msgfrm);
            $("#msgfrm").removeClass("waiting");
            console.log("Frm Loaded..");
            closeWaitDialog();
        }
    });
}

function loadFrm(nodeId, msgobj) {
    $.ajax({
        type: "GET",
        url: schemaroot + nodeId + '/' + nodeId + "_Form.html.lz",
        dataType: "text",
        success: function (fhtmstr) {
            var frmstr = LZString.decompressFromUTF16(fhtmstr);
            var msgfrm = $.parseHTML(frmstr);
            $("#msgfrm").append(msgfrm);
            var mobj = {
                name: nodeId,
                storename: "GoEMessages",
                data: msgobj.data,
                xmlview: msgobj.xmlview,
                xmldoc: msgobj.xmldoc,
                xmlfrm: fhtmstr
            };
            updateRecord("GoEMessages", mobj, function () {
                $("#" + nodeId).css('color', 'green');
                $("#msgfrm").removeClass("waiting");
                console.log("Doc Loaded..");
                closeWaitDialog();
            });
        },
        fail: function () {
            console.log("Could not retrieve file: " + rpath);
        }
    });
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
    $("#waitdialog").children("p").text("");
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