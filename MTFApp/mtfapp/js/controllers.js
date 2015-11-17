/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl */

mtfApp.controller('mtfCtl', function () {
    var mtfctl = this;
    mtfctl.nodeSelected = [];
    mtfctl.listSelected = [];
    mtfctl.valuefilter = function (mlist, txt, field) {
        var result = {
        };
        angular.forEach(mlist, function (value, key) {
            if (typeof value.Info !== "undefined") {
                if (typeof txt === "undefined") {
                    result[key] = value.Info[field];
                } else if (typeof value.Info[field] !== "undefined") {
                    if (value.Info[field].toLowerCase().indexOf(txt.toLowerCase()) > -1) {
                        result[key] = value.Info[field];
                    }
                }
            }
        });
        return result;
    };
    mtfctl.selectNode = function (list, node, k) {
        mtfctl.selected = k;
        mtfctl.listSelected = list;
        mtfctl.nodeSelected = node;
    };
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };

});

mtfApp.controller('usmsgCtl', function (dbService) {
    var umsgctl = this;
    umsgctl.view = "views/msgView.html";
    umsgctl.usmsg = [];
    dbService.getUIData('umsgs_ui', function (jsonres) {
        angular.forEach(jsonres.Messages.Message, function (msg) {
            umsgctl.usmsg.push({'Info': msg.Info});
        });
    });
});
mtfApp.controller('ussegCtl', function (dbService) {
    var ussegctl = this;
    ussegctl.view = "views/segmentView.html";
    ussegctl.usseg = [];
    dbService.getUIData('usegments_ui', function (jsonres) {
        angular.forEach(jsonres.Segments.Segment, function (seg) {
            ussegctl.usseg.push({'Info': seg.Info});
        });
    });
});
mtfApp.controller('ussetCtl', function (dbService) {
    var ussetctl = this;
    ussetctl.view = "views/setView.html";
    ussetctl.usset = [];
    dbService.getUIData('usets_ui', function (jsonres) {
        angular.forEach(jsonres.Sets.Set, function (set) {
            ussetctl.usset.push({'Info': set.Info});
        });
    });
});
mtfApp.controller('usfldCtl', function (dbService) {
    var usfldctl = this;
    usfldctl.view = "views/fieldView.html";
    usfldctl.usfld = [];
    dbService.getUIData('ufields_ui', function (jsonres) {
        angular.forEach(jsonres.Fields.Field, function (fld) {
            usfldctl.usfld.push({'Info': fld.Info});
        });
    });
});

mtfApp.controller('natomsgCtl', function (dbService) {
    var nmsgctl = this;
    nmsgctl.view = "views/msgView.html";
    nmsgctl.natomsg = [];
    dbService.getUIData('nmsgs_ui', function (jsonres) {
         angular.forEach(jsonres.Messages.Message, function (msg) {
            nmsgctl.natomsg.push({'Info': msg.Info});
        });
    });
});
mtfApp.controller('natosegCtl', function (dbService) {
    var nsegctl = this;
    nsegctl.view = "views/segmentView.html";
    nsegctl.natoseg = [];
    dbService.getUIData('nsegments_ui', function (jsonres) {
         angular.forEach(jsonres.Segments.Segment, function (seg) {
             nsegctl.natoseg.push({'Info': seg.Info});
        });
    });
});
mtfApp.controller('natosetCtl', function (dbService) {
    var nsetctl = this;
    nsetctl.view = "views/setView.html";
    nsetctl.natoset = [];
    dbService.getUIData('nsets_ui', function (jsonres) {
          angular.forEach(jsonres.Sets.Set, function (set) {
            nsetctl.natoset.push({'Info': set.Info});
        });
    });
});
mtfApp.controller('natofldCtl', function (dbService) {
    var nfldctl = this;
    nfldctl.view = "views/fieldView.html";
    nfldctl.natofld = [];
    dbService.getUIData('nfields_ui', function (jsonres) {
          angular.forEach(jsonres.Fields.Field, function (fld) {
            nfldctl.natofld.push({'Info': fld.Info});
        });;
    });
});

mtfApp.controller('menuCtrl', function ($scope) {
    //initiate an array to hold all active tabs
    $scope.activeTabs = [];
    //check if the tab is active
    $scope.isOpenTab = function (tab) {
        //check if this tab is already in the activeTabs array
        if ($scope.activeTabs.indexOf(tab) > -1) {
            //if so, return true
            return true;
        } else {
            //if not, return false
            return false;
        }
    };
    //function to 'open' a tab
    $scope.openTab = function (tab) {
        //check if tab is already open
        if ($scope.isOpenTab(tab)) {
            //if it is, remove it from the activeTabs array
            $scope.activeTabs.splice($scope.activeTabs.indexOf(tab), 1);
        } else {
            //if it's not, add it!
            $scope.activeTabs.push(tab);
        }
    };
    //function to leave a tab open if open or open if not
    $scope.leaveOpenTab = function (tab) {
        //check if tab is already open
        if (!$scope.isOpenTab(tab)) {
            //if it is not open, add to array
            $scope.activeTabs.push(tab);
        }
    };
});