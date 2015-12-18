/* global mtfApp, angular, msgctl, setctl, segctl, umsgctl, ussegctl, ussetctl, usfldctl, nmsgctl, nsegctl, nsetctl */

mtfApp.controller('mtfCtl', function ($scope, dbService, uiService) {
    var mtfctl = this;
    $scope.isArray = angular.isArray;
    $scope.mtftxtsearch = 'ACC';
    mtfctl.view = '';
    mtfctl.childnode = false;
    dbService.syncResources(mtfctl, uiService, function () {
        $scope.umsgs_ui = mtfctl.umsgs_ui;
        $scope.nmsgs_ui = mtfctl.nmsgs_ui;
        $scope.usegments_ui = mtfctl.usegments_ui;
        $scope.nsegments_ui = mtfctl.nsegments_ui;
        $scope.usets_ui = mtfctl.usets_ui;
        $scope.nsets_ui = mtfctl.nsets_ui;
        $scope.ufields_ui = mtfctl.ufields_ui;
        $scope.nfields_ui = mtfctl.nfields_ui;
        console.log("Sync complete");
    });
});

mtfApp.controller('viewCtl', function ($scope, dbService, uiService) {
    var vwctl = this;
    $scope.isArray = angular.isArray;
    $scope.mtftxtsearch = 'ACC';
    vwctl.view = '';
    vwctl.viewTypes = {
        'umsgs_ui': 'message',
        'nmsgs_ui': 'message',
        'usegments_ui': 'segment',
        'nsegments_ui': 'segment',
        'usets_ui': 'set',
        'nsets_ui': 'set',
        'ufields_ui': 'field',
        'nfields_ui': 'field'
    };
    vwctl.valuefilter = function (mlist, txt, field) {
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
    vwctl.listfilter = function (mlist, txt) {
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
    vwctl.selectNode = function (type,list, node, k) {
        vwctl.selected = k;
        vwctl.type = type;
        vwctl.list = list;
        vwctl.node = node;
        $scope.list = list;
        vwctl.sel = node;
        //console.log(list);
        console.log(vwctl.node);
    };
    vwctl.isSelected = function (k) {
        return vwctl.selected === k;
    };
    vwctl.tabs = {
        usmtf: {tabid: 'usmtf', tabtitle: 'USMTF'},
        usmtfmsg: {tabid: 'usmtfmsg', tabtitle: 'Messages'},
        usmtfseg: {tabid: 'usmtfseg', tabtitle: 'Segments'},
        usmtfset: {tabid: 'usmtfset', tabtitle: 'Sets'},
        usmtffld: {tabid: 'usmtffld', tabtitle: 'Fields'},
        natomtf: {tabid: 'natomtf', tabtitle: 'NATO MTF'},
        natomtfmsg: {tabid: 'natomtfmsg', tabtitle: 'Messages'},
        natomtfseg: {tabid: 'natomtfseg', tabtitle: 'Segments'},
        natomtfset: {tabid: 'natomtfset', tabtitle: 'Sets'},
        natomtffld: {tabid: 'natomtffld', tabtitle: 'Fields'}
    };
});
//
mtfApp.controller('fldCtl', function ($scope, dbService, uiService) {
    var fldctl = this;
    fldctl.fldctlvw="templates/field.html";
    fldctl.setvw="templates/set.html";
    fldctl.isArray = angular.isArray;
    fldctl.childnode = false;
    fldctl.fldGetType = function (f) {
        if (typeof f !== 'undefined') {
            if (typeof f.seq !== 'undefined') {
                return false;
            } else if (typeof f.choice !== 'undefined') {
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
        if (typeof seq !== 'undefined') {
            return false;
        } else if (typeof choice !== 'undefined') {
            if (typeof choice.enumeration[0] !== 'undefined') {
                return false;
            } else if (Object.keys(choice).length === 1) {
                return true;
            } else {
                return false;
            }
        }
    };
    fldctl.getFieldList = function (listname) {
        if (listname === 'ufields_ui') {
            return $scope.ufields_ui;
        } else if (listname === 'nfields_ui') {
            return $scope.nfields_ui;
        } else if (listname === 'usets_ui') {
            return $scope.ufields_ui;
        } else if (listname === 'nsets_ui') {
            return $scope.nfields_ui;
        }
    };
    fldctl.getSetList = function () {
        if ($scope.listname === 'usets_ui') {
            return $scope.usets_ui;
        } else if ($scope.listname === 'nsets_ui') {
            return $scope.nsets_ui;
        }
    };
    fldctl.setRefs = function (objseq,slist) {
        if (typeof objseq !== 'undefined') {
            var flds = [];
            var k = (Object.keys(objseq));
            //console.log(k);
            var fnode = [];
            //var slist = fldctl.getSetList();
            for (i = 0; i < k.length; i++) {
                if (k[i].substring(k[i].length - 3) === 'Set') {
                    //console.log(k[i]);
                    if (typeof objseq[k[i]] !== 'undefined') {
                        fnode[k[i]] = objseq[k[i]];
                        var f = fldctl.getFieldDef(slist, k[i], fnode[k[i]]);                        
                        fldctl.combineNodes(f, fnode[k[i]], i);
                        f.position = i;
                        flds.push(f);
                    }
                }
            }
            //console.log(flds);
            return (flds);
        }
    };
    fldctl.fldRefs = function (objseq,flist) {
        if (typeof objseq !== 'undefined') {
            var flds = [];
            var flds = [];
            var k = (Object.keys(objseq));
            //console.log(k);
            var fnode = [];
            //var flist = fldctl.getFieldList(listname);
            //console.log(flist);
            for (i = 0; i < k.length; i++) {
                if (typeof objseq[k[i]] !== 'undefined') {
                    fnode[k[i]] = objseq[k[i]];
                    var f = fldctl.getFieldDef(flist, k[i], fnode[k[i]]);
                    if (typeof f === 'undefined') {
                        f = fnode[k[i]];
                    }
                    f.child = true;
                    f.name = k[i];
                    if (typeof f.name !== 'undefined') {
                        fldctl.combineNodes(f, fnode[k[i]], i);
                        flds.push(f);
                    }
                }
            }
            //console.log(flds);
            return flds;
        }
    };
    fldctl.getFieldDef = function (flist, ky, fnode) {
        if (typeof flist[ky] !== 'undefined') {
            return flist[ky];
        } else if (typeof fnode._ref !== 'undefined') {
            if (typeof flist[fnode._ref] !== 'undefined') {
                return flist[fnode._ref];
            } else if (typeof flist[fnode._ref.substring(6)] !== 'undefined') {
                return flist[fnode._ref.substring(6)];
            }
        } else if (typeof fnode._type !== 'undefined') {
            if (typeof flist[fnode._type.substring(0, fnode._type.length - 4)] !== 'undefined') {
                return flist[fnode._type.substring(0, fnode._type.length - 4)];
            } else if (typeof flist[fnode._type.substring(6, fnode._type.length - 4)] !== 'undefined') {
                return flist[fnode._type.substring(6, fnode._type.length - 4)];
            }
        } else if (typeof fnode._base !== 'undefined') {
            if (typeof flist[fnode._base.substring(0, fnode._base.length - 4)] !== 'undefined') {
                return angular.copy(flist[fnode._base.substring(0, fnode._base.length - 4)]);
            } else if (typeof flist[fnode._base.substring(6, fnode._base.length - 4)] !== 'undefined') {
                return angular.copy(flist[fnode._base.substring(6, fnode._base.length - 4)]);
            }
        } else {
            return fnode;
        }
    }
    fldctl.combineNodes = function (fref, fnode, pos) {
        if (typeof fref !== 'undefined') {
            if (typeof fref.Info !== 'undefined' && typeof fnode.Info !== 'undefined') {
                fref.Info._name = fnode.Info._name;
                fref.Info._positionName = fnode.Info._positionName;
                fref.Info._definition = fnode.Info._definition;
                fref.Info._identifier = fnode.Info._identifier;
                fref.Info._remark = fnode.Info._remark;
                fref.Info._usage = fnode.Info._usage;
                fref.Info._version = fnode.Info._version;
            }
            fref._minOccurs = fnode._minOccurs;
            fref._maxOccurs = fnode._maxOccurs;
            fref._nillable = fnode._nillable;
            fref.position = pos;
        } else {
            fref = fnode;
            fref._minOccurs = fnode._minOccurs;
            fref._maxOccurs = fnode._maxOccurs;
            fref._nillable = fnode._nillable;
            fref.position = pos;
        }
    }
});
//
mtfApp.controller('tabCtrl', function ($scope) {
    var tabctl = this;
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
    tabctl.tabCss = [];
    tabctl.tabCss['USMTF'] = 'mtftab-title';
    tabctl.tabCss['NATO MTF'] = 'mtftab-title';
    tabctl.tabCss['Messages'] = 'mtftab-title_sm';
    tabctl.tabCss['Segments'] = 'mtftab-title_sm';
    tabctl.tabCss['Sets'] = 'mtftab-title_sm';
    tabctl.tabCss['Fields'] = 'mtftab-title_sm';

});