/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl, ussegctl, ussetctl, usfldctl, nmsgctl, nsegctl, nsetctl */
mtfApp.controller('mtfCtl', function ($scope, dbService, uiService) {
    var mtfctl = this;
    $scope.isArray = angular.isArray;
    mtfctl.view = '';
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
        'ufields_ui': 'views/fieldView.html',
        'nfields_ui': 'views/fieldView.html',
        'usets_ui': 'views/setView.html',
        'nsets_ui': 'views/setView.html',
        'usegments_ui': 'views/segmentView.html',
        'nsegments_ui': 'views/segmentView.html',
        'umessages_ui': 'views/messageView.html',
        'nmessages_ui': 'views/messageView.html'
    };
    mtfctl.fieldView = "views/fieldView.html";
    mtfctl.setView = "views/setView.html";
    mtfctl.segmentView = "views/segmentView.html";
    mtfctl.messageView = "views/messageView.html";
    mtfctl.sequenceView = "views/sequenceView.html";
    mtfctl.choiceView = "views/choiceView.html";
    dbService.syncResources(mtfctl, uiService, function () {
        console.log("Sync complete");
        $scope.umsgs_ui = mtfctl.umsgs_ui;
        $scope.nmsgs_ui = mtfctl.nmsgs_ui;
        $scope.usegments_ui = mtfctl.usegments_ui;
        $scope.nsegments_ui = mtfctl.nsegments_ui;
        $scope.usets_ui = mtfctl.usets_ui;
        $scope.nsets_ui = mtfctl.nsets_ui;
        $scope.ufields_ui = mtfctl.ufields_ui;
        $scope.nfields_ui = mtfctl.nfields_ui;
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
        $scope.listname = list;
        $scope['node'] = node;
        mtfctl.view = mtfctl.views[list];
        console.log($scope.node);
    };
    //
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };
});
//
mtfApp.controller('fldCtl', function ($scope, dbService, uiService) {
    var fldctl = this;
    fldctl.fldGetType = function (f) {
        if (typeof f.seq != 'undefined') {
            return false;
        } else if (typeof f.choice != 'undefined') {
            return false;
        } else if (f._base === 'FieldIntegerBaseType') {
            return 'Integer';
        } else if (f._base === 'FieldDecimalBaseType') {
            return 'Decimal';
        } else if (typeof f._minLength !== 'undefined' | typeof f._length !== 'undefined') {
            return 'String';
        } else {
            return false;
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
    fldctl.fldInfoList = function (node) {
        if (typeof node === 'undefined') {
            return false;
        } else if (typeof node.Info === 'undefined') {
            return false;
        } else if (typeof node.Info[0] !== 'undefined') {
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
    fldctl.getFieldList = function () {
        if ($scope.listname === 'ufields_ui') {
            return $scope.ufields_ui;
        } else if ($scope.listname === 'nfields_ui') {
            return $scope.nfields_ui;
        } else if ($scope.listname === 'usets_ui') {
            return $scope.ufields_ui;
        } else if ($scope.listname === 'nsets_ui') {
            return $scope.nfields_ui;
        }
    };
    fldctl.fldRefs = function (objseq) {
        if (typeof objseq !== 'undefined') {
            var flds =[];
            var fldrefs =[];
            var flds =[];
            var k =(Object.keys(objseq));
            var fnode =[];
            var flist = fldctl.getFieldList();
            for (i = 0; i < k.length; i++) {
                if (typeof objseq[k[i]] !== 'undefined') {
                    if (typeof flist[k[i]] !== 'undefined') {
                        fnode[k[i]] = objseq[k[i]];
                        fldrefs[k[i]] = fldctl.getFieldDef(flist, k[i], fnode[k[i]]);
                        if (typeof fldrefs[k[i]] !== 'undefined') {
                            if (typeof fldrefs[k[i]].Info !== 'undefined' && typeof fnode[k[i]].Info !== 'undefined') {
                                //console.log(fnode[k[i]].Info._positionName);
                                fldrefs[k[i]].Info._positionName = fnode[k[i]].Info._positionName;
                                fldrefs[k[i]].Info._definition = fnode[k[i]].Info._definition;
                                fldrefs[k[i]].Info._identifier = fnode[k[i]].Info._identifier;
                                fldrefs[k[i]].Info._remark = fnode[k[i]].Info._remark;
                                fldrefs[k[i]].Info._version = fnode[k[i]].Info._version;
                            }
                            fldrefs[k[i]]._minOccurs = fnode[k[i]]._minOccurs;
                            fldrefs[k[i]]._maxOccurs = fnode[k[i]]._maxOccurs;
                            fldrefs[k[i]]._nillable = fnode[k[i]]._nillable;
                            fldrefs[k[i]].position = i;
                            //flds.push(fldrefs[k[i]]);
                        } else {
                            fldrefs[k[i]] = fnode[k[i]];
                            fldrefs[k[i]].position = i;
                            fldrefs[k[i]]._minOccurs = fnode[k[i]]._minOccurs;
                            fldrefs[k[i]]._maxOccurs = fnode[k[i]]._maxOccurs;
                            fldrefs[k[i]]._nillable = fnode[k[i]]._nillable;
                            //flds.push(fldrefs[k[i]]);
                        }
                    }
                }
            }
            //console.log(flds);
            return (fldrefs);
        }
    };
    fldctl.getFieldDef = function (flist, ky, fnode) {
        if (typeof flist[ky] !== 'undefined') {
            return flist[ky];
        } else if (typeof fnode._ref !== 'undefined') {
            if (typeof flist[fnode._ref] !== 'undefined') {
                return flist[fnode._ref];
            } else if (flist[fnode._ref.substring(6)] !== 'undefined') {
                return flist[fnode._ref.substring(6)];
            }
        } else if (typeof fnode._type !== 'undefined') {
            if (typeof flist[fnode._type.substring(0, fnode._type.length -4)] !== 'undefined') {
                return flist[fnode._type.substring(0, fnode._type.length -4)];
            } else if (flist[fnode._type.substring(6, fnode._type.length -4)] !== 'undefined') {
                return flist[fnode._type.substring(6, fnode._type.length -4)];
            }
        } else if (typeof fnode._base !== 'undefined') {
            if (typeof flist[fnode._base.substring(0, fnode._base.length -4)] !== 'undefined') {
                return angular.copy(flist[fnode._base.substring(0, fnode._base.length -4)]);
            } else if (flist[fnode._base.substring(6, fnode._base.length -4)] !== 'undefined') {
                return angular.copy(flist[fnode._base.substring(6, fnode._base.length -4)]);
            }
        }
    }
});
//
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