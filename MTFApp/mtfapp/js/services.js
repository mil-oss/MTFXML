
/* global mtfApp */

mtfApp.factory('dbService', function ($http, $indexedDB, $q) {
    var dbsvc = {
    };
    dbsvc.resources = {
        usmtf_msgs: '/xml/lz/usmtf_messages.xsd.lz',
        usmtf_segs: '/xml/lz/usmtf_segments.xsd.lz',
        usmtf_sets: '/xml/lz/usmtf_sets.xsd.lz',
        usmtf_flds: '/xml/lz/usmtf_fields.xsd.lz',
        nato_msgs: '/xml/lz/nato_messages.xsd.lz',
        nato_segs: '/xml/lz/nato_segments.xsd.lz',
        nato_sets: '/xml/lz/nato_sets.xsd.lz',
        nato_flds: '/xml/lz/nato_fields.xsd.lz',
        msgs_ui: '/xml/lz/messagesUI.xsl.lz',
        sets_ui: '/xml/lz/setsUI.xsl.lz',
        segments_ui: '/xml/lz/segmentsUI.xsl.lz',
        fields_ui: '/xml/lz/fieldsUI.xsl.lz'
    };
    dbsvc.xj = new X2JS();
    dbsvc.dB = $indexedDB;
<<<<<<< HEAD
    dbsvc.saxonloaded = false;
    dbsvc.xslproc = [];

    dbsvc.onSaxonLoad = function () {
        console.log('saxon loaded');
        saxonloaded = true;
    };

    dbsvc.getUIData = function (uixsl, uidata, callback) {
        console.log('getUIData ' + uidata);
        dbsvc.dB.openStore('MTF', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(uidata) === -1) {
                    dbsvc.uiXSL(uixsl, uidata, callback);
                } else {
                    store.find(uidata).then(function (uidbrec) {
                        dbsvc.dB.openStore('Resources', function (resstore) {
                            resstore.find(uidata).then(function (resdbrec) {
                                if (resdbrec.lastmod !== uidbrec.lastmod) {
                                    console.log('update data');
                                    dbsvc.uiXSL(uixsl, uidata, callback);
                                } else {
                                    callback(uidbrec.data);
                                }
                            });
                        });

                    });
                }
            });
        });
    };

    dbsvc.uiXSL = function (xslname, xmlsrc, callback) {
        console.log('uiXSL ' + xslname + ' ' + xmlsrc);
        if (typeof dbsvc.xslproc[xslname] === 'undefined') {
            dbsvc.getResource(xslname, function (xslres) {
                var xslstr = xslres.data;
                var xsldoc = Saxon.parseXML(xslstr);
                dbsvc.xslproc[xslname] = Saxon.newXSLT20Processor(xsldoc);
                dbsvc.getResource(xmlsrc, function (xmlres) {
                    var xmlstr = xmlres.data;
                    var xdoc = Saxon.parseXML(xmlstr);
                    var xslresult = dbsvc.xslproc[xslname].transformToFragment(xdoc);
                    var uixml = Saxon.serializeXML(xslresult);
                    var uijson = dbsvc.xj.xml_str2json(uixml);
                    dbsvc.dB.openStore('MTF', function (mtfstore) {
                        mtfstore.upsert({name: xmlsrc, lastmod: xmlres.lastmod, data: uijson}).then(function () {
                            callback(uijson);
                        });
                    });
                });
            });
        } else {
            dbsvc.getResource(xmlsrc, function (xmlres) {
                var xmlstr = xmlres.data;
                var xdoc = Saxon.parseXML(xmlstr);
                var xslresult = dbsvc.xslproc[xslname].transformToFragment(xdoc);
                var uixml = Saxon.serializeXML(xslresult);
                var uijson = dbsvc.xj.xml_str2json(uixml);
                dbsvc.dB.openStore('MTF', function (mtfstore) {
                    mtfstore.upsert({name: xmlsrc, lastmod: xmlres.lastmod, data: uijson}).then(function () {
                        callback(uijson);
                    });
                });
            });
        }
    };

    dbsvc.getResource = function (resource, callback) {
        console.log('getResource ' + resource);
        var xname = resource;
        var xurl = dbsvc.resources[resource];
=======
    dbsvc.syncResources = function (allres, callback) {
        var promises = [];
        var k = Object.keys(allres);
        for (i = 0; i < k.length; i++) {
            promises.push(dbsvc.syncResource(k[i]));
        }
        $q.all(promises).then(function () {
            callback();
        });
    };

    dbsvc.syncResource = function (res) {
        console.log('syncResource ' + res);
        var deferred = $q.defer();
        var xname = res;
        var xurl = resources[res];
        var jsonname = xname + '.json';
        //console.log(xname + ", " + jsonname);
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(xname) === -1) {
                    console.log("No Local Store .. Add: " + xurl);
                    $http.get(xurl).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.dB.openStore('Resources', function (store) {
                            store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata}).then(function () {
<<<<<<< HEAD
                                var xstr = LZString.decompressFromUTF16(resdata);
                                callback({'data': xstr, 'lastmod': mod});
=======
                                deferred.resolve();
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
                            });
                        });
                    }).error(function () {
                        console.log('Error getting resource ' + xname);
                        deferred.reject();
                    });
                } else {
                    store.find(xname).then(function (dbrec) {
                        $http.head(xurl).success(function (resdata, status, headers) {
                            var mod = headers()['last-modified'];
                            //console.log(mod);
                            if (dbrec.lastmod !== mod) {
                                console.log(xname + "Modified ..Update");
                                $http.get(xurl).success(function (resdata, status, headers) {
                                    dbsvc.dB.openStore('Resources', function (store) {
                                        store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata}).then(function () {
<<<<<<< HEAD
                                            var xstr = LZString.decompressFromUTF16(resdata);
                                            callback({'data': xstr, 'lastmod': mod});
=======
                                            deferred.resolve();
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
                                        });
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                    deferred.reject();
                                });
                            } else {
<<<<<<< HEAD
                                var xstr = LZString.decompressFromUTF16(resdata);
                                callback({'data': xstr, 'lastmod': mod});
=======
                                deferred.resolve();
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
                            }
                        }).error(function () {
                            console.log('Error getting headers for ' + xname);
                            deferred.reject();
                        });
                    });
                }
            });
        });
    };

<<<<<<< HEAD
=======
    dbsvc.updateUIData = function (xsltService) {
        xsltService.doXSL('fields_ui', 'usmtf_flds');
        xsltService.doXSL('sets_ui', 'usmtf_sets');
        xsltService.doXSL('segments_ui', 'usmtf_segmenets');
        xsltService.doXSL('msgs_ui', 'usmtf_messages');
        xsltService.doXSL('fields_ui', 'nato_flds');
        xsltService.doXSL('sets_ui', 'nato_sets');
        xsltService.doXSL('segments_ui', 'nato_segmenets');
        xsltService.doXSL('msgs_ui', 'nato_messages');
    };

    dbsvc.getData = function (resname, rootnode) {
        console.log('msgList ' + resname);
        dbsvc.dB.openStore('Resources', function (store) {
            store.find(resname).then(function (r) {
                console.log(r.data[rootnode]);
                return r.data[rootnode];
            });
        });
    };
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
    return dbsvc;
});

<<<<<<< HEAD
=======
mtfApp.factory('xsltService', function ($indexedDB) {
    var xslsvc = {
    };
    xslsvc.dB = $indexedDB;
    xslsvc.saxonloaded = false;
    xslsvc.xslproc = [];
    xslsvc.onSaxonLoad = function () {
        console.log('saxon loaded');
        saxonloaded = true;
    };
    xslsvc.initXSL = function (xslname) {
        console.log('initXSL ' + xslname);
        xslsvc.dB.openStore('Resources', function (store) {
            store.find(xslname).then(function (r) {
                var xslstr = LZString.decompressFromUTF16(r.data);
                xslsvc.xslproc[xslname] = Saxon.newXSLT20Processor(Saxon.parseXML(xslstr));
            });
        });
    };
    xslsvc.setParams = function (xslname, params) {
        if (params) {
            for (p = 0; p < params.length; p++) {
                xslsvc.xslproc[xslname].setParameter(null, params[p].name, params[p].value);
            }
        }
    }
    xslsvc.doXSL = function (xslname, xmlsrc, params) {
        console.log('doXSL ' + xslname);
        if (typeof xslsvc.xslproc[xslname] === 'undefined') {
            xslsvc.initXSL(xslname);
            xslsvc.setParams(xslname, params);
            xslsvc.doXSLfromDb(xslname, xmlsrc);
        } else {
            xslsvc.setParams(xslname, params);
            xslsvc.doXSLfromDb(xslname, xmlsrc);
        }
    };
    xslsvc.doXSLfromDb = function (xslname, xmlsrc) {
        xslsvc.dB.openStore('Resources', function (store) {
            store.find(xmlsrc).then(function (r) {
                var xmlstr = LZString.decompressFromUTF16(r.data);
                //console.log(xmlstr);
                var xdoc = Saxon.parseXML(xmlstr);
                //console.log(xmlsrc+" "+xdoc);
                var result = xslsvc.xslproc[xslname].transformToFragment(xdoc);
                xslsvc.dB.openStore('MTF', function (mtfstore) {
                    mtfstore.upsert({name: xmlsrc, data: Saxon.serializeXML(result)});
                });
            });
        });
    };

    return xslsvc;
})
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git

mtfApp.factory('DlgBx', function ($window, $q) {
    var dlg = {
    };
    dlg.alert = function alert(message) {
        var defer = $q.defer();
        $window.alert(message);
        defer.resolve();
        return (defer.promise);
    };
    dlg.prompt = function prompt(message, defaultValue) {
        var defer = $q.defer();
        // The native prompt will return null or a string.
        var response = $window.prompt(message, defaultValue);
        if (response === null) {
            defer.reject();
        } else {
            defer.resolve(response);
        }
        return (defer.promise);
    };
    dlg.confirm = function confirm(message) {
        var defer = $q.defer();
        // The native confirm will return a boolean.
        if ($window.confirm(message)) {
            defer.resolve(true);
        } else {
            defer.reject(false);
        }
        return (defer.promise);
    };
    return dlg;
});

