/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl, ussegctl, ussetctl, usfldctl, nmsgctl, nsegctl, nsetctl */
mtfApp.controller('mtfCtl', function ($scope, dbService, uiService) {
    var mtfctl = this;
    mtfctl.selNode =[];
    mtfctl.listSelected =[];
    mtfctl.showView ='';
    mtfctl.views = {
        'umsgs_ui': 'message',
        'nmsgs_ui': 'message',
        'usegments_ui': 'segment',
        'nsegments_ui': 'segment',
        'usets_ui': 'set',
        'nsets_ui': 'set',
        'ufields_ui': 'field',
        'nfields_ui': 'field'
    };
    dbService.syncResources(uiService, mtfctl, function () {
        console.log("Sync complete");
        //console.log(mtfctl.ufields_ui);
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
        mtfctl.showView = mtfctl.views[list];
        $scope.selNode = node;
        $scope.selData = mtfctl[list];
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
    var fldsui=[];
    fldctl.hasType=false;
    $scope.$watch("selNode", function () {
        fldctl.field = $scope.selNode;
        console.log($scope.selNode);
    });
    fldctl.getType=function(base,seq,choice){
        if (typeof seq != 'undefined' | typeof choice != 'undefined') {
            fldctl.hasType=false;
        } else if (base==='FieldIntegerBaseType') {
            fldctl.hasType=true;
            return 'Integer';
        } else if (base==='FieldDecimalBaseType') {
            fldctl.hasType=true;
            return 'Decimal';
        }else{
            fldctl.hasType=true;
            return 'String';
        }
    };
    fldctl.enums = function (seq, choice) {
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
    fldctl.infoList = function (field) {
        if (typeof field !== 'undefined') {
            if (typeof field.Info[0] !== 'undefined') {
                return true;
            } else {
                return false;
            }
        }
    };
    fldctl.singleenum = function (seq, choice) {
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
    fldctl.getRefs = function (sequence) {
    if (typeof sequence !== 'undefined') {
        var flds = [];
        var k =(Object.keys(sequence));
        for (i = 0; i < k.length; i++) {
            console.log(k[i]);
            flds.push($scope.selData[k[i]]);
        }
        console.log(flds);
        return (flds);
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