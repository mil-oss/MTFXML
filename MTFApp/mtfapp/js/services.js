
mtfApp.factory('dbService', function ($http, $indexedDB, $q) {
    var dbsvc = {
    };
    dbsvc.xj = new X2JS();
    dbsvc.dB = $indexedDB;
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
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(xname) === -1) {
                    console.log("No Local Store .. Add: " + xurl);
                    $http.get(xurl).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.dB.openStore('Resources', function (store) {
                            store.upsert({name: xname, url: xurl, lastmod: mod, data: resdata}).then(function () {
                                deferred.resolve();
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
                                            deferred.resolve();
                                        });
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                    deferred.reject();
                                });
                            } else {
                                deferred.resolve();
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
    return dbsvc;
});

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

