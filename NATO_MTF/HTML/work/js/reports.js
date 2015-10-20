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
var msgid = null;
var setid = null;
var fldid = null;
var xmlViewXSLProc = null;
var msgRptXSL = null;
var setRptXSL = null;
var fieldRptXSL = null;
var nodeXSL = null;
var xmlser = new XMLSerializer();

function getXMLViewReport(xsdtemplate, xsd, tagname,target,dbstore,callback) {
    var baselineTemplate = null;
    var goeTemplate = null;
    if (nodeXSL === null) {
        nodeXSL = Saxon.requestXML(dUrlList[ 'NodeTreeHtm.xsl']);
        xmlViewXSLProc = Saxon.newXSLT20Processor(nodeXSL);
    }
    var node = $(xsd).children().children("[name='" + tagname + "']");
    var elnode = $(xsd).children().children("[type='" + tagname + "']");
    var n = xmlser.serializeToString($(node)[0]);
    var s = xmlser.serializeToString($(xsdtemplate)[0]);
    var schemat = $.parseXML(s);
    $(schemat).find("schema").append($(n));
    if (elnode.length !== 0) {
        var en = xmlser.serializeToString($(elnode)[0]);
        $(schemat).find("schema").append($(en));
    }
    var params =[[ 'tagName', tagname]];
    $(target).empty();
    for (i = 0; i < params.length; i++) {
        xmlViewXSLProc.setParameter(null, params[i][0], params[i][1]);
    }
    var result = xmlViewXSLProc.transformToFragment(schemat, document);
    var vwstr = xmlser.serializeToString(result);
    $(target).append(result);
    callback(vwstr);
}

function getFieldReport(fid) {
    console.log("getFieldReport: " + fid);
    getRecord("Resources", 'field_docs.html', function (res) {
        var ddoc = $.parseHTML(res.data);
        var d = $(ddoc).children().children("div[id='" + fid + "']")
        alert(d)
        $("#xsdview").empty();
        $("#xsdview").append(d);
    });
    getRecord("Resources", 'field_forms.html', function (res) {
        var fdoc = $.parseHTML(res.data);
        var f = $(fdoc).children().children("div[id='" + fid + "']")
        alert(f)
        $("#reportview").empty();
        $("#reportview").append(f);
    });
}

function getMsgReport(msgid) {
    console.log("getMsgReport: " + msgid);
    getRecord("BaselineMessages", msgid, function (uimsgobj) {
        if (typeof uimsgobj !== "undefined") {
            var xmldom = Saxon.parseXML(uimsgobj.data);
            if (msgRptXSL === null) {
                msgRptXSL = Saxon.requestXML(dUrlList[ 'msgrpt.xsl']);
            }
            var params =[[ 'setdocpath', dUrlList[ 'sets.xsd']]];
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
            var params =[[ 'fieldsdocpath', dUrlList[ 'fields.xsd']],[ 'compositesdocpath', dUrlList[ 'composites.xsd']]];
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
        fldid = null;
    } else if (dbstore === "BaselineSets") {
        $("#showview").show();
        setid = $(node).find('SetFormatIdentifier').text();
        //console.log(setid);
        msgid = null;
        fldid = null;
    } else {
        $("#showview").show();
        fldid = $(node).attr("name");
        console.log("fldid: " + fldid);
        msgid = null;
        setid = null;
    }
}