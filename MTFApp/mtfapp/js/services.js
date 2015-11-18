
/* global mtfApp, LZString */

mtfApp.factory('dbService', function ($http, $indexedDB) {
    var dbsvc = {
    };
    dbsvc.resources = {
//        usmtf_msgs: '/xml/lz/usmtf_messages.xsd.lz',
//        usmtf_segs: '/xml/lz/usmtf_segments.xsd.lz',
//        usmtf_sets: '/xml/lz/usmtf_sets.xsd.lz',
//        usmtf_flds: '/xml/lz/usmtf_fields.xsd.lz',
//        nato_msgs: '/xml/lz/nato_messages.xsd.lz',
//        nato_segs: '/xml/lz/nato_segments.xsd.lz',
//        nato_sets: '/xml/lz/nato_sets.xsd.lz',
//        nato_flds: '/xml/lz/nato_fields.xsd.lz',
//        umsgs_ui: '/xml/lz/usmtf_messages_ui.xml.lz',
        usets_ui: '/xml/lz/usmtf_sets_ui.xml.lz',
//        usegments_ui: '/xml/lz/usmtf_segments_ui.xml.lz',
        ufields_ui: '/xml/lz/usmtf_fields_ui.xml.lz',
//        nmsgs_ui: '/xml/lz/nato_messages_ui.xml.lz',
        nsets_ui: '/xml/lz/nato_sets_ui.xml.lz',
//        nsegments_ui: '/xml/lz/nato_segments_ui.xml.lz',
        nfields_ui: '/xml/lz/nato_fields_ui.xml.lz'
    };

    dbsvc.dB = $indexedDB;

    dbsvc.syncResources = function (uiService,mtfctl,callback) {
        console.log("syncResources " + Object.keys(dbsvc.resources).length);
        var count = 0;
        for (var k in dbsvc.resources) {
            //console.log("load " + k);
            dbsvc.getResource(k, function (res) {
                if (res['name'].substring(res['name'].length - 2) === 'ui') {
                    uiService.synchUIData(res['name'], res.data, res.lastmod, dbsvc.dB, function (uiname,uidata) {
                        mtfctl[uiname]=jsonPath(uidata, '$.*.*.*.Info._name');
                       count++;
                        if (count === Object.keys(dbsvc.resources).length) {
                            callback();
                        }
                    });
                } else {
                    count++;
                    if (count === Object.keys(dbsvc.resources).length) {
                        callback();
                    }
                }
            });
        }
    };

    dbsvc.getResource = function (resource, callback) {
        //console.log('getResource ' + resource);
        var xname = resource;
        var xurl = dbsvc.resources[resource];
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(xname) === -1) {
                    //console.log("No Local Store .. Add: " + xurl);
                    $http.get(xurl).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.decompress(resdata, function (dcmp) {
                            callback({'name': xname, 'data': dcmp, 'lastmod': mod});
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
                                        callback({'name': xname, 'data': dcmp, 'lastmod': mod});
                                    });
                                    dbsvc.dB.openStore('Resources', function (store) {
                                        store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata});
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                });
                            } else {
                                dbsvc.decompress(dbdata, function (dcmp) {
                                    //console.log('Return cached ');
                                    callback({'name': xname, 'data': dcmp, 'lastmod': mod});
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

    dbsvc.decompress = function (cdata, callback) {
        var d = LZString.decompressFromUTF16(cdata);
        callback(d);
    };

    dbsvc.compress = function (udata, callback) {
        var c = LZString.compressToUTF16(udata);
        callback(c);
    };

    return dbsvc;

});

mtfApp.factory('uiService', function ($http) {
    var uisvc = {
    };
    uisvc.xslproc = [];
    uisvc.saxonloaded = false;
    uisvc.xslproc = null;

    uisvc.onSaxonLoad = function () {
        console.log('saxon loaded');
        uisvc.saxonloaded = true;
    };

    uisvc.xj = new X2JS();

    uisvc.synchUIData = function (uiname, uidata, lastmod, IDB, callback) {
        //console.log('synchUIData ' + uiname);
        IDB.openStore('MTF', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(uiname) === -1) {
                    uisvc.toJson(uidata, function (jrslt) {
                        IDB.openStore('MTF', function (mtfstore) {
                            mtfstore.upsert({name: uiname, lastmod: lastmod, data: jrslt}).then(function () {
                                callback(uiname,jrslt);
                            });
                        });
                    });
                } else {
                    store.find(uiname).then(function (uidbrec) {
                        if (uidbrec.lastmod !== lastmod) {
                            uisvc.toJson(uidata, function (jrslt) {
                                IDB.openStore('MTF', function (mtfstore) {
                                    mtfstore.upsert({name: uiname, lastmod: lastmod, data: jrslt}).then(function () {
                                        callback(uiname,jrslt);
                                    });
                                });
                            });
                        } else {
                            //console.log('local data not modified');
                            callback(uiname,uidbrec.data);
                        }
                    });

                }
            });
        });
    };

    uisvc.getUIList = function (uiname, IDB, callback) {
        IDB.openStore('MTF', function (store) {
            store.find(uiname).then(function (uijson) {
                var uilist = jsonPath(uijson.data, '$.*.*.*.Info._name');
                callback(uilist);
            });
        });
    };
    
    uisvc.getUINode = function (uiname, index,IDB, callback) {
        var jpath='$.*.*['+index+']';
        IDB.openStore('MTF', function (store) {
            store.find(uiname).then(function (uijson) {
                var uinode = jsonPath(uijson.data, jpath);
                callback(uinode);
            });
        });
    };

    uisvc.getUIData = function (uidata, dbService, callback) {
        console.log('getUIData ' + uidata);
        dbService.dB.openStore('MTF', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(uidata) === -1) {
                    dbService.getResource(uidata, function (xrslt) {
                        uisvc.toJson(xrslt.data, function (jrslt) {
                            callback(jrslt);
                            dbService.dB.openStore('MTF', function (mtfstore) {
                                mtfstore.upsert({name: uidata, lastmod: xrslt.lastmod, data: jrslt});
                            });
                        });
                    });
                } else {
                    store.find(uidata).then(function (uidbrec) {
                        dbService.dB.openStore('Resources', function (resstore) {
                            resstore.find(uidata).then(function (resdbrec) {
                                if (resdbrec.lastmod !== uidbrec.lastmod) {
                                    dbService.getResource(uidata, function (xrslt) {
                                        uisvc.toJson(xrslt.data, function (jrslt) {
                                            callback(jrslt);
                                            dbService.dB.openStore('MTF', function (mtfstore) {
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

    uisvc.uiXSL = function (xslname, xmlsrc, dbService, callback) {
        console.log('uiXSL ' + xslname + ' ' + xmlsrc);
        uisvc.getResource(xslname, function (xslres) {
            var xslstr = xslres.data;
            dbService.getResource(xmlsrc, function (xmlres) {
                var xmlstr = xmlres.data;
                uisvc.xslTransform(xslstr, xmlstr, function (xrslt) {
                    uisvc.toJson(xrslt, function (jrslt) {
                        if (jrslt !== null) {
                            callback(jrslt);
                            dbService.dB.openStore('MTF', function (mtfstore) {
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

    uisvc.xslTransform = function (xslstr, xmlstr, callback) {
        uisvc.xslproc = Saxon.newXSLT20Processor(Saxon.parseXML(xslstr));
        var xslresult = uisvc.xslproc.transformToFragment(Saxon.parseXML(xmlstr));
        var uixml = Saxon.serializeXML(xslresult);
        callback(uixml);
    };

    uisvc.toJson = function (xdata, callback) {
        var uijson = uisvc.xj.xml_str2json(xdata);
        callback(uijson);
    };

    return uisvc;
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

