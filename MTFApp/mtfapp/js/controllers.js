/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl, ussegctl, ussetctl, usfldctl, nmsgctl, nsegctl, nsetctl */
mtfApp.controller('mtfCtl', function ($scope, dbService, uiService) {
    var mtfctl = this;
    mtfctl.selNode =[];
    $scope.listSelected =[];
    mtfctl.viewTypes = {
        'umsgs_ui': 'message',
        'nmsgs_ui': 'message',
        'usegments_ui': 'segment',
        'nsegments_ui': 'segment',
        'usets_ui': 'set',
        'nsets_ui': 'set',
        'ufields_ui': 'field',
        'nfields_ui': 'field'
    };
    mtfctl.views = {
        'field': 'views/fieldView.html',
        'set': 'views/setView.html',
        'segment': 'views/segmentView.html',
        'message': 'views/messageView.html'
    };
    mtfctl.fieldView="views/fieldView.html";
    mtfctl.setView="views/setView.html";
    mtfctl.segmentView="views/segmentView.html";
    mtfctl.messageView="views/messageView.html";
    dbService.syncResources(uiService, mtfctl, function () {
        console.log("Sync complete");
    });
    mtfctl.valuefilter = function (mlist, txt, field) {
        var result = {
        };
        angular.forEach(mlist, function (value, key) {
            if (typeof value.Info !== "undefined") {
                if (typeof txt === "undefined") {
                    if (typeof value.Info[0] !== "undefined") {
                        result[key] = value.Info[0][field];
                    } else {
                        result[key] = value.Info[field];
                    }
                } else if (typeof value.Info[field] !== "undefined" | value.Info[field] !== '') {
                    if (typeof value.Info[0] !== "undefined") {
                        if (value.Info[0][field].toLowerCase().indexOf(txt.toLowerCase()) > -1) {
                            result[key] = value.Info[0][field];
                        }
                    } else if (typeof value.Info[field] !== "undefined") {
                        if (value.Info[field].toLowerCase().indexOf(txt.toLowerCase()) > -1) {
                            result[key] = value.Info[field];
                        }
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
    mtfctl.selectNode = function (list, node, k) {
        mtfctl.selected = k;
        $scope.listSelected = mtfctl[list];
        $scope[mtfctl.viewTypes[list]] = node;
        mtfctl.view = mtfctl.views[mtfctl.viewTypes[list]];
        console.log($scope.field);
    };
    //
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };
});
mtfApp.controller('fldCtl', function ($scope, dbService, uiService) {
    var fldctl = this;
    fldctl.fldHasType = false;
    fldctl.fldGetType = function (base, seq, choice) {
        if (typeof seq != 'undefined' | typeof choice != 'undefined') {
            fldctl.fldHasType = false;
        } else if (base === 'FieldIntegerBaseType') {
            fldctl.fldHasType = true;
            return 'Integer';
        } else if (base === 'FieldDecimalBaseType') {
            fldctl.fldHasType = true;
            return 'Decimal';
        } else {
            fldctl.fldHasType = true;
            return 'String';
        }
    };
    fldctl.fldEnums = function (seq, choice) {
        if (typeof seq != 'undefined') {
            return false;
        } else if (typeof choice !== 'undefined') {
            if (typeof choice.enumeration[0] !== 'undefined') {
                return true;
            } else {
                return false;
            }
        }
    };
    fldctl.fldInfoList = function (field) {
        if (typeof field === 'undefined') {
            return false;
        } else if (typeof field.Info === 'undefined') {
            return false;
        } else if (typeof field.Info[0] !== 'undefined') {
            return true;
        } else {
            return false;
        }
    };
    fldctl.fldSingleEnum = function (seq, choice) {
        if (typeof seq != 'undefined') {
            return false;
        } else if (typeof choice !== 'undefined') {
            if (typeof choice.enumeration[0] !== 'undefined') {
                return false;
            } else if (Object.keys(choice).length == 1) {
                return true;
            } else {
                return false;
            }
        }
    }
    fldctl.fldRefs = function (sequence) {
        if (typeof sequence !== 'undefined') {
            var flds =[];
            var k =(Object.keys(sequence));
            for (i = 0; i < k.length; i++) {
                flds.push($scope.listSelected[k[i]]);
            }
            return (flds);
        }
    };
});
mtfApp.controller('setCtl', function ($scope, dbService, uiService) {
    var setctl = this;
    setctl.fldInfoList = function (field) {
        if (typeof field === 'undefined') {
            return false;
        } else if (typeof field.Info === 'undefined') {
            return false;
        } else if (typeof field.Info[0] !== 'undefined') {
            return true;
        } else {
            return false;
        }
    };
    setctl.setRefs = function (sequence) {
        if (typeof sequence !== 'undefined') {
            var nodes =[];
            var k =(Object.keys(sequence));
            for (i = 0; i < k.length; i++) {
                nodes.push($scope.listSelected[k[i]]);
            }
            return (nodes);
        }
    };
});
mtfApp.controller('menuCtrl', function ($scope) {
    //initiate an array to hold all active tabs
    $scope.activeTabs =[];
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
        if (! $scope.isOpenTab(tab)) {
            //if it is not open, add to array
            $scope.activeTabs.push(tab);
        }
    };
});