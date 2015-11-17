
/* global mtfApp, LZString */

mtfApp.factory('dbService', function ($http, $indexedDB) {
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
        umsgs_ui: '/xml/lz/usmtf_messages_ui.xml.lz',
        usets_ui: '/xml/lz/usmtf_sets_ui.xml.lz',
        usegments_ui: '/xml/lz/usmtf_segments_ui.xml.lz',
        ufields_ui: '/xml/lz/usmtf_fields_ui.xml.lz',
        nmsgs_ui: '/xml/lz/nato_messages_ui.xml.lz',
        nsets_ui: '/xml/lz/nato_sets_ui.xml.lz',
        nsegments_ui: '/xml/lz/nato_segments_ui.xml.lz',
        nfields_ui: '/xml/lz/nato_fields_ui.xml.lz'
    };

    dbsvc.xj = new X2JS();
    dbsvc.dB = $indexedDB;
    dbsvc.saxonloaded = false;
    dbsvc.xslproc = null;

    dbsvc.onSaxonLoad = function () {
        console.log('saxon loaded');
        dbsvc.saxonloaded = true;
        dbsvc.xslproc = Saxon.newXSLT20Processor();
    };

    dbsvc.getUIData = function (uidata, callback) {
        console.log('getUIData ' + uidata);
        dbsvc.dB.openStore('MTF', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(uidata) === -1) {
                    dbsvc.getResource(uidata, function (xrslt) {
                        dbsvc.toJson(xrslt.data, function (jrslt) {
                            callback(jrslt);
                            dbsvc.dB.openStore('MTF', function (mtfstore) {
                                mtfstore.upsert({name: uidata, lastmod: xrslt.lastmod, data: jrslt});
                            });
                        })
                    });
                } else {
                    store.find(uidata).then(function (uidbrec) {
                        dbsvc.dB.openStore('Resources', function (resstore) {
                            resstore.find(uidata).then(function (resdbrec) {
                                if (resdbrec.lastmod !== uidbrec.lastmod) {
                                    dbsvc.getResource(uidata, function (xrslt) {
                                        dbsvc.toJson(xrslt.data, function (jrslt) {
                                            callback(jrslt);
                                            dbsvc.dB.openStore('MTF', function (mtfstore) {
                                                mtfstore.upsert({name: uidata, lastmod: xrslt.lastmod, data: jrslt});
                                            });
                                        });
                                    });
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
        dbsvc.getResource(xslname, function (xslres) {
            var xslstr = xslres.data;
            dbsvc.getResource(xmlsrc, function (xmlres) {
                var xmlstr = xmlres.data;
                dbsvc.xslTransform(xslstr, xmlstr, function (xrslt) {
                    dbsvc.toJson(xrslt, function (jrslt) {
                        if (jrslt !== null) {
                            callback(jrslt);
                            dbsvc.dB.openStore('MTF', function (mtfstore) {
                                mtfstore.upsert({name: xmlsrc, lastmod: xmlres.lastmod, data: jrslt});
                            });
                        } else {
                            console.log("Error with transform");
                        }
                    })
                })
            });
        });
    };

    dbsvc.getResource = function (resource, callback) {
        console.log('getResource ' + resource);
        var xname = resource;
        var xurl = dbsvc.resources[resource];
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(xname) === -1) {
                    console.log("No Local Store .. Add: " + xurl);
                    $http.get(xurl).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.decompress(resdata, function (dcmp) {
                            callback({'data': dcmp, 'lastmod': mod});
                        });
                        dbsvc.dB.openStore('Resources', function (store) {
                            store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata});
                        });
                    }).error(function () {
                        console.log('Error getting resource ' + xname);
                    });
                } else {
                    store.find(xname).then(function (dbrec) {
                        var dbdata = dbrec.data;
                        $http.head(xurl).success(function (resdata, status, headers) {
                            var mod = headers()['last-modified'];
                            if (dbrec.lastmod !== mod) {
                                console.log(xname + "Modified ..Update");
                                $http.get(xurl).success(function (resdata, status, headers) {
                                    dbsvc.decompress(resdata, function (dcmp) {
                                        callback({'data': dcmp, 'lastmod': mod});
                                    });
                                    dbsvc.dB.openStore('Resources', function (store) {
                                        store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata});
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                });
                            } else {
                                dbsvc.decompress(dbdata, function (dcmp) {
                                    console.log('Return cached ');
                                    callback({'data': dcmp, 'lastmod': mod});
                                })
                            }
                        }).error(function () {
                            console.log('Error getting headers for ' + xname);
                        });
                    });
                }
            });
        });
        return dbsvc;
    };

    dbsvc.xslTransform = function (xslstr, xmlstr, callback) {
        dbsvc.xslproc = Saxon.newXSLT20Processor(Saxon.parseXML(xslstr));
        var xslresult = dbsvc.xslproc.transformToFragment(Saxon.parseXML(xmlstr));
        var uixml = Saxon.serializeXML(xslresult);
        callback(uixml);
    };

    dbsvc.toJson = function (xdata, callback) {
        var uijson = dbsvc.xj.xml_str2json(xdata);
        callback(uijson);
    };

    dbsvc.decompress = function (cdata, callback) {
        var d = LZString.decompressFromUTF16(cdata);
        callback(d);
    };

    return dbsvc;

});


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

