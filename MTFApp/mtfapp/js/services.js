
mtfApp.factory('dbService', function ($http, $indexedDB, $q) {
    var dbsvc = {
    };
    dbsvc.xj = new X2JS();
    ;
    dbsvc.dB = $indexedDB;
    dbsvc.syncResource = function (res) {
        console.log('syncResource ' + res);
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
                            var dstr = LZString.decompressFromUTF16(resdata);
                            var xjson = dbsvc.xj.xml_str2json(dstr)
                            store.upsert({name: xname, url: xurl, lastmod: mod, data: xjson});
                            //dbsvc.setList(xname, xjson, mtfctl);
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
                                        var xjson = dbsvc.xj.xml_str2json(dstr);
                                        store.upsert({name: xname, url: xurl, lastmod: mod, data: xjson});
                                        //dbsvc.setList(xname, xjson, mtfctl);
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + xname);
                                });
                            } else {
                                //dbsvc.setList(xname, dbrec.data, mtfctl);
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
    dbsvc.getData = function (resname,rootnode) {
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

