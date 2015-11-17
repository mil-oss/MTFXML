/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl */

mtfApp.controller('mtfCtl', function (dbService) {
    var mtfctl = this;
    mtfctl.selNode = [];
    mtfctl.listSelected = [];
    mtfctl.sequenceview = 'views/sequenceView.html';
    mtfctl.choiceview = 'views/choiceView.html';
    mtfctl.setview = 'views/setView.html';
    mtfctl.segmentview = 'views/segmentView.html';
    mtfctl.fieldview = 'views/fieldView.html';
    mtfctl.views=
        {'msgs':'views/msgView.html',
        'segs':'views/segmentView.html',
        'sets':'views/setView.html',
        'flds':'views/fieldView.html'};
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
        mtfctl.view=mtfctl.views[list];
        mtfctl.selNode = node;
        
    };
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };

});

mtfApp.controller('usmsgCtl', function (dbService) {
    var umsgctl = this;
    umsgctl.usmsg = [];
    dbService.getUIData('umsgs_ui', function (jsonres) {
        umsgctl.usmsg=jsonres.Messages;
    });
});
mtfApp.controller('ussegCtl', function (dbService) {
    var ussegctl = this;
    ussegctl.usseg = [];
    dbService.getUIData('usegments_ui', function (jsonres) {
        ussegctl.usseg =jsonres.Segments;
    });
});
mtfApp.controller('ussetCtl', function (dbService) {
    var ussetctl = this;
    ussetctl.usset = [];
    dbService.getUIData('usets_ui', function (jsonres) {
        ussetctl.usset =jsonres.Sets;
    });
});
mtfApp.controller('usfldCtl', function (dbService) {
    var usfldctl = this;
    usfldctl.usfld = [];
    dbService.getUIData('ufields_ui', function (jsonres) {
        usfldctl.usfld =jsonres.Fields;
    });
});

mtfApp.controller('natomsgCtl', function (dbService) {
    var nmsgctl = this;
    nmsgctl.natomsg = [];
    dbService.getUIData('nmsgs_ui', function (jsonres) {
        nmsgctl.natomsg =jsonres.Messages;
    });
});
mtfApp.controller('natosegCtl', function (dbService) {
    var nsegctl = this;
    nsegctl.natoseg = [];
    dbService.getUIData('nsegments_ui', function (jsonres) {
        nsegctl.natoseg =jsonres.Segments;
    });
});
mtfApp.controller('natosetCtl', function (dbService) {
    var nsetctl = this;
    nsetctl.natoset = [];
    dbService.getUIData('nsets_ui', function (jsonres) {
        nsetctl.natoset =jsonres.Sets;
    });
});
mtfApp.controller('natofldCtl', function (dbService) {
    var nfldctl = this;
    nfldctl.natofld = [];
    dbService.getUIData('nfields_ui', function (jsonres) {
        nfldctl.natofld =jsonres.Fields;
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