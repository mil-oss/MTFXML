
mtfApp.factory('dbService', function ($http, $indexedDB, $q) {
    var dbsvc = {
    };
    dbsvc.xj = new X2JS();
    ;
    dbsvc.dB = $indexedDB;
    dbsvc.syncResource = function (mtfctl, res) {
        console.log('syncResource ' + res.url);
        var xname = res.name;
        var xurl = res.url;
        var jsonname = xname + '.json';
        console.log(name + ", " + jsonname);
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(jsonname) === -1) {
                    console.log("No Local Store .. Add: " + res.url);
                    $http.get(xurl).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.dB.openStore('Resources', function (store) {
                            //console.log(resdata);
                            var dstr = LZString.decompressFromUTF16(resdata);
                            var xjson = dbsvc.xj.xml_str2json(dstr)
                            store.upsert({name: xname, url: xurl, lastmod: mod, data: xjson});
                            dbsvc.setVal(mtfctl, xname, xjson);
                        });
                    }).error(function () {
                        console.log('Error getting resource ' + xname);
                    });
                } else {
                    store.find(xname).then(function (dbrec) {
                        $http.head(xurl).success(function (resdata, status, headers) {
                            var mod = headers()['last-modified'];
                            console.log(mod);
                            if (dbrec.lastmod !== mod) {
                                console.log(xname + "Modified ..Update");
                                $http.get(xurl).success(function (resdata, status, headers) {
                                    dbsvc.dB.openStore('Resources', function (store) {
                                        var dstr = LZString.decompressFromUTF16(resdata);
                                        var xjson = dbsvc.xj.xml_str2json(dstr)
                                        store.upsert({name: xname, url: xurl, lastmod: mod, data: xjson});
                                    }).then(function () {
                                        dbsvc.setVal(mtfctl, xname, xjson);
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                });
                            } else {
                                dbsvc.setVal(mtfctl, xname, dbrec.data);
                            }
                        }).error(function () {
                            console.log('Error getting headers for ' + xname);
                        });
                        ;
                    });
                }
            });
        });
    };
    dbsvc.setVal = function (mtfctl, fname, data) {
        //console.log('setVal: ' + fname);
        if (fname === 'usmtf_msgs') {
            mtfctl.usmsgs = data;
        } else if (fname === 'usmtf_segs') {
            mtfctl.ussegments = data;
        } else if (fname === 'usmtf_sets') {
            mtfctl.ussets = data;
        } else if (fname === 'usmtf_flds') {
            mtfctl.usfields = data;
        } else if (fname === 'nato_msgs') {
            mtfctl.natomsgs = data;
        } else if (fname === 'nato_segs') {
            mtfctl.natosets = data;
        } else if (fname === 'nato_sets') {
            mtfctl.natofields = data;
        } else if (fname === 'nato_flds') {
            mtfctl.natosegments = data;
        }
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

