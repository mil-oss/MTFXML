
mtfApp.factory('dbService', function ($http, $indexedDB, $q) {
    var dbsvc = {
    };
    dbsvc.xj = new X2JS();
    ;
    dbsvc.dB = $indexedDB;
    dbsvc.syncResource = function (mtfctl, url) {
        console.log('syncResource ' + url);
        var filename = url.substring(url.lastIndexOf('/') + 1);
        var jsonname = filename.substring(0, filename.lastIndexOf('.')) + '.json';
        var jsonurl = "/json/" + jsonname;
        console.log(jsonname);
        var xjson = null;
        dbsvc.dB.openStore('Resources', function (store) {
            store.getAllKeys().then(function (keys) {
                if (keys.indexOf(jsonname) === -1) {
                    console.log("No Local Store .. Add: " + jsonname);
                    $http.get(url).success(function (resdata, status, headers) {
                        var mod = headers()['last-modified'];
                        dbsvc.dB.openStore('Resources', function (store) {
                            store.upsert({name: jsonname, url: jsonurl, lastmod: mod, data: resdata});
                            dbsvc.setVal(mtfctl,jsonname, resdata);
                        });
                    }).error(function () {
                        console.log('Error getting resource ' + filename);
                    });
                } else {
                    store.find(jsonname).then(function (dbrec) {
                        $http.head(url).success(function (resdata, status, headers) {
                            var mod = headers()['last-modified'];
                            console.log(mod);
                            if (dbrec.lastmod !== mod) {
                                console.log(filename + "Modified ..Update");
                                $http.get(url).success(function (resdata, status, headers) {
                                    dbsvc.dB.openStore('Resources', function (store) {
                                        store.upsert({name: jsonname, url: jsonurl, lastmod: mod, data: resdata});
                                    }).then(function () {
                                        dbsvc.setVal(mtfctl,jsonname, resdata);
                                    });
                                }).error(function () {
                                    console.log('Error getting resource ' + filename);
                                });
                            } else {
                                dbsvc.setVal(mtfctl,jsonname, dbrec.data);
                            }
                        }).error(function () {
                            console.log('Error getting headers for ' + filename);
                        });
                        ;
                    });
                }
            });
        });
    };
    dbsvc.setVal = function (mtfctl,fname, data) {
        //console.log('setVal: ' + fname);
        if (fname === 'GoE_messages.json') {
            mtfctl.usmsgs = data;
            console.log(mtfctl.usmsgs);
        } else if (fname === 'GoE_segments.json') {
            mtfctl.ussegments = data;
        } else if (fname === 'GoE_sets_ui.json') {
            mtfctl.ussets = data;
        } else if (fname === 'GoE_fields_ui.json') {
            mtfctl.usfields = data;
        } else if (fname === 'natomtf_messages.json') {
            mtfctl.natomsgs = data;
        } else if (fname === 'natomtf_sets.json') {
            mtfctl.natosets = data;
        } else if (fname === 'natomtf_fields.json') {
            mtfctl.natofields = data;
        } else if (fname === 'natomtf_segments.json') {
            mtfctl.natosegments = data;
        }
    }
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

