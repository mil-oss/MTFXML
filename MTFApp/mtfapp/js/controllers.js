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
        $scope[mtfctl.viewTypes[list]] = node;
        mtfctl.view = mtfctl.views[list];
        console.log($scope[mtfctl.viewTypes[list]]);
    };
    //
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };
});
//
mtfApp.controller('fldCtl', function ($scope, dbService, uiService) {
    var fldctl = this;
    fldctl.fldHasType = false;
    fldctl.fldGetType = function (base, seq, choice) {
        if (typeof seq != 'undefined') {
            fldctl.fldHasType = false;
        } else if (typeof choice != 'undefined') {
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
    fldctl.fldRefs = function (objseq) {
        if (typeof objseq !== 'undefined') {
            var flds =[];
            var fldref =[];
            if ($scope.listname === 'ufields_ui') {
                fldctl.flist = $scope.ufields_ui;
            } else if ($scope.listname === 'nfields_ui') {
                fldctl.flist = $scope.nfields_ui;
            } else if ($scope.listname === 'usets_ui') {
                fldctl.flist = $scope.ufields_ui;
            } else if ($scope.listname === 'nsets_ui') {
                fldctl.flist = $scope.nfields_ui;
            }
            var k =(Object.keys(objseq));
            for (i = 0; i < k.length; i++) {
                if (typeof objseq[k[i]] !== 'undefined') {
                    if (typeof fldctl.flist[k[i]] !== 'undefined') {
                        fldref = fldctl.flist[k[i]];
                        if(fldref._name==='WidthOfAccessFeetYardsOrMetres'){
                            console.log(fldref);
                        }
                        fldref.position = i;
                        if (typeof objseq[k[i]].Info !== 'undefined') {
                            fldref.Info._explanation = objseq[k[i]].Info._explanation;
                            fldref.Info._usage = objseq[k[i]].Info._usage;
                            fldref.Info._remark = objseq[k[i]].Info._remark;
                            fldref.Info._version = objseq[k[i]].Info._version;
                            fldref.Info._definition = objseq[k[i]].Info._definition;
                            fldref.Info._identifier = objseq[k[i]].Info._identifier;
                            flds.push(fldref);
                        } else {
                            flds.push(fldref);
                        }
                    } else if (typeof objseq[k[i]].Info !== 'undefined') {
                        fldref = objseq[k[i]];
                        fldref.position = i;
                        flds.push(fldref);
                    }
                }
            }
            //console.log(flds);
            return (flds);
        }
    };
});
//
mtfApp.controller('setCtl', function ($scope, dbService, uiService) {
    var setctl = this;
    setctl.setRefs = function (objseq) {
        //console.log(objseq);
        if (typeof objseq !== 'undefined') {
            var nodes =[];
            setctl.slist =[];
            setctl.flist =[];
            if ($scope.listname === 'usets_ui') {
                setctl.slist = $scope.usets_ui;
                setctl.flist = $scope.ufields_ui;
            } else if ($scope.listname === 'nsets_ui') {
                setctl.slist = $scope.nsets_ui;
                setctl.flist = $scope.nfields_ui;
            }
            var k =(Object.keys(objseq));
            for (i = 0; i < k.length; i++) {
                //console.log(k[i]);
                if (k[i].substring(k[i].length -3) === 'Set') {
                    var s = setctl.slist[k[i]];
                    s._minOccurs = objseq[k[i]]._minOccurs;
                    s._maxOccurs = objseq[k[i]]._maxOccurs;
                    s._nillable = objseq[k[i]]._nillable;
                    s._minLength = objseq[k[i]]._minLength;
                    s._maxLength = objseq[k[i]]._maxLength;
                    s.position = i;
                    nodes.push(s);
                }
            }
            console.log(nodes);
            return (nodes);
        }
    };
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