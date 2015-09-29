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
var AllMsgs = null;
var AllMsgUrl = null;
var AllSets = null;
var AllFields = null;
var viewXSD = null;
var msgXSD = null;
var setsXSD = null;
var fieldsXSD = null;
var msgDOC = null;
var msgTpl = null;
var setTpl = null;
var fieldTpl = null;
var viewXSDProc = null;
var msgXSDProc = null;
var setsXSDProc = null;
var fieldsXSDProc = null;
var msgDOCProc = null;
var target = null;
var currentNode;
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
            west__paneSelector: "#msgview",
            west__size: .33,
            west__childOptions: {
                north__size: .04,
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0,
                center__childOptions: {
                    north__size: .4,
                    north__paneSelector: "#msgxsd",
                    center__size: .3,
                    center__paneSelector: "#msgdoc",
                    south__size: .3,
                    south__paneSelector: "#msgfrm"
                }
            },
            center__paneSelector: "#setsview",
            center__size: .33,
            center__childOptions: {
                north__size: .04,
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0,
                center__childOptions: {
                    north__size: .4,
                    north__paneSelector: "#setsxsd",
                    center__size: .3,
                    center__paneSelector: "#setsdoc",
                    south__size: .3,
                    south__paneSelector: "#setsfrm"
                }
            },
            east__paneSelector: "#fieldsview",
            east__size: .33,
            east__childOptions: {
                north__size: .04,
                north__resizable: false,
                north__slidable: false,
                north__spacing_open: 0,
                center__childOptions: {
                    north__size: .4,
                    north__paneSelector: "#fieldsxsd",
                    center__size: .4,
                    center__paneSelector: "#fieldsdoc",
                    south__size: .3,
                    south__paneSelector: "#fieldsfrm"
                }
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
        $(res).css("color", "green");
    });
}

function getNode(el) {
    console.log("getNode");
    var jel = $(el);
    var label = jel.text();
    var nodeId = jel.attr("id");
    $("#sidebar").addClass("waiting");
    $("#msgxsd").empty();
    $("#msgxsd").addClass("waiting");
    $("#setsxsd").empty();
    $("#setsxsd").addClass("waiting");
    $("#fieldsxsd").empty();
    $("#fieldsxsd").addClass("waiting");
    if (AllMsgs === null) {
        getRecord("Resources", "natomtf_goe_messages.xsd.lz", function (mdoc) {
            AllMsgs = Saxon.parseXML(LZString.decompressFromUTF16(mdoc.data));
            getRecord("Resources", "natomtf_goe_sets.xsd.lz", function (sdoc) {
                AllSets = Saxon.parseXML(LZString.decompressFromUTF16(sdoc.data));
                getRecord("Resources", "natomtf_goe_composites.xsd.lz", function (cdoc) {
                    AllComposites = Saxon.parseXML(LZString.decompressFromUTF16(cdoc.data));
                    getRecord("Resources", "natomtf_goe_fields.xsd.lz", function (fdoc) {
                        AllFields = Saxon.parseXML(LZString.decompressFromUTF16(fdoc.data));
                        getRecord("Resources", "NodeTreeHtm.xsl.lz", function (vxsl) {
                            viewXSD = Saxon.parseXML(LZString.decompressFromUTF16(vxsl.data));
                            viewXSDProc = Saxon.newXSLT20Processor(viewXSD);
                            getRecord("Resources", "GoE_Msg_XSD.xsl.lz", function (mxsl) {
                                msgXSD = Saxon.parseXML(LZString.decompressFromUTF16(mxsl.data));
                                msgXSDProc = Saxon.newXSLT20Processor(msgXSD);
                                msgXSDProc.setParameter(null, "Msgs", AllMsgs);
                                msgXSDProc.setParameter(null, "Sets", AllSets);
                                msgXSDProc.setParameter(null, "Composites", AllComposites);
                                msgXSDProc.setParameter(null, "Fields", AllFields);
                                //msgXSDProc.setInitialTemplate("makeXSD");
                                getMsgSchemas(tagname, label)
/*                                getRecord("Resources", "GoE_Msg_Doc.xsl.lz", function (dxsl) {
                                    msgDOC = Saxon.parseXML(LZString.decompressFromUTF16(dxsl.data));
                                    msgDOCProc = Saxon.newXSLT20Processor(msgDOC);
                                    target = Saxon.parseXML(xsltarget);
                                    getMsgSchemas(tagname, label)
                                });*/
                            });
                        });
                    });
                });
            });
        });
    } else {
        getMsgSchemas(tagname, label);
    }
}

function getMsgSchemas(tagname, label) {
    console.log("getMsg "+tagname);
    target = Saxon.parseXML(xsltarget);
    getRecord("GoEMessages", tagname, function (msgobj) {
        if (typeof msgobj === "undefined") {
             msgXSDProc.setInitialTemplate("makeXSD");
             msgXSDProc.setParameter(null, "msgtype", tagname + "Type");
             var msgxsd = msgXSDProc.transformToDocument(null);
             alert(xmlser.serializeToString(msgxsd));
            /*msgXSDProc.setInitialTemplate("getMsg");
            msgXSDProc.setParameter(null, "msgtype", tagname + "Type");
            var msgxsd = msgXSDProc.transformToDocument(null);
            alert(xmlser.serializeToString(msgxsd));
            msgXSDProc.setInitialTemplate("getSets");
            msgXSDProc.setParameter(null, "message", msgxsd);
            var setsxsd = msgXSDProc.transformToDocument(null);
            alert(xmlser.serializeToString(setsxsd));*/
           /* var mnode=$(msgxsd).children("msgxsd").children("message");
            var snode=$(msgxsd).children("msgxsd").children("sets");
            var cnode=$(msgxsd).children("msgxsd").children("composites");
            var fnode=$(msgxsd).children("msgxsd").children("fields");*/
/*            viewXSDProc.setParameter(null, 'tagName', label);
            var msgvw = viewXSDProc.transformToFragment(msgxsd, document);
            viewXSDProc.clearParameters();
            var msgwstr = xmlser.serializeToString($(msgvw)[0]);;
            $("#msgxsd").append(xmlser.serializeToString(msgvw));
            var mobj = {
                name: tagname,
                storename: "GoEMessages",
                data: xmlser.serializeToString($(msgxsd)[0]),
                xmlview: xmlser.serializeToString($(msgvw)[0])
            };
            addRecord("GoEMessages", mobj, callback(tagname, label, $(msgxsd)[0], getFieldsSchema));
            $("#msg_" + tagname).css('color', 'green');
            $('#msgxsd').removeClass("waiting");*/
        } else {
            $("#msgxsd").empty();
            $("#msgxsd").append(msgobj.xmlview);
            $('#msgxsd').removeClass("waiting");
            callback(tagname, label, $.parseXML(msgobj.data), getFieldsSchema)
        }
    });
}

function getMsgDoc(msgxsd) {
}

function getSetsDoc(msgxsd) {
}

function getFieldsDoc(msgxsd) {
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
        },
        {
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