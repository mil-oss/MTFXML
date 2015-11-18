/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl, ussegctl, ussetctl, usfldctl, nmsgctl, nsegctl, nsetctl */

mtfApp.controller('mtfCtl', function ($scope, dbService, uiService) {
    var mtfctl = this;
    mtfctl.selNode = [];
    mtfctl.listSelected = [];
    mtfctl.sequenceview = 'views/sequenceView.html';
    mtfctl.choiceview = 'views/choiceView.html';
    mtfctl.setview = 'views/setView.html';
    mtfctl.segmentview = 'views/segmentView.html';
    mtfctl.fieldview = 'views/fieldView.html';

    mtfctl.views = {
        'umsgs_ui': 'views/msgView.html',
        'nmsgs_ui': 'views/msgView.html',
        'usegments_ui': 'views/segmentView.html',
        'nsegments_ui': 'views/segmentView.html',
        'usets_ui': 'views/setView.html',
        'nsets_ui': 'views/setView.html',
        'ufields_ui': 'views/fieldView.html',
        'nfields_ui': 'views/fieldView.html'};
    dbService.syncResources(uiService, mtfctl, function () {
        //
        console.log("Sync complete");
    });
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
    mtfctl.listfilter = function (mlist, txt) {
        var result = {
        };
        angular.forEach(mlist, function (value, key) {
            if (typeof value !== "undefined") {
                if (typeof txt === "undefined") {
                    result[key] = value;
                } else {
                    if (value.toLowerCase().indexOf(txt.toLowerCase()) > -1) {
                        result[key] = value;
                    }
                }
            }
        });
        return result;
    };
    mtfctl.selectNode = function (list, txt, k, idx) {
        mtfctl.selected = k;
        $scope.selNode = {'data': list, 'index': idx};
        mtfctl.view = mtfctl.views[list];
    };
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };
});
mtfApp.controller('msgCtl', function ($scope, uiService, dbService) {
    var msgctl = this;
});
mtfApp.controller('segCtl', function ($scope, uiService, dbService) {
    var ussegctl = this;
});
mtfApp.controller('setCtl', function ($scope, uiService, dbService) {
    var ussetctl = this;
});
mtfApp.controller('fldCtl', function ($scope, uiService, dbService) {
    var fldctl = this;
    $scope.$watch("selNode", function () {
        uiService.getUINode($scope.selNode.data, $scope.selNode.index, dbService.dB, function (node) {
            fldctl.Field = node[0];
            console.log(fldctl.Field);
        });
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