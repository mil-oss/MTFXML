<<<<<<< HEAD

/* global mtfApp, angular, msgctl, setctl, segctl */

mtfApp.controller('mtfCtl', function () {
=======
mtfApp.controller('mtfCtl', function ($scope, DlgBx, dbService, xsltService) {
>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
    var mtfctl = this;
    mtfctl.messageview = "views/msgView.html";
    mtfctl.segmentview = "views/segmentView.html";
    mtfctl.setview = "views/setView.html";
    mtfctl.fieldview = "views/fieldView.html";
    mtfctl.view = "";
<<<<<<< HEAD
    mtfctl.nodeSelected = [];
    mtfctl.listSelected = [];
=======
    //
    
    dbService.syncResources(resources,function(){
        console.log("data loaded");
        dbService.updateUIData(xsltService);
    }); 
    

>>>>>>> branch 'master' of https://github.com/mil-oss/MTFXML.git
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
        mtfctl.view = "views/msgView.html";
        mtfctl.selected = k;
        mtfctl.listSelected = list;
        mtfctl.nodeSelected = node;
        console.log(mtfctl.nodeSelected);
    };
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };

});

mtfApp.controller('msgCtl', function (dbService) {
    var msgctl = this;
    msgctl.view = "views/msgView.html";
    msgctl.usmsg = [];
    msgctl.natomsg = [];
    dbService.getUIData('msgs_ui', 'nato_msgs', function (jsonres) {
        msgctl.usmsg = jsonres.Messages;
    });
    dbService.getUIData('msgs_ui', 'usmtf_msgs', function (jsonres) {
        msgctl.natomsg = jsonres.Messages;
    });
});

mtfApp.controller('segmentCtl', function (dbService) {
    var segctl = this;
    segctl.view = "views/segmentView.html";
    segctl.usseg = [];
    segctl.natoseg = [];
    dbService.getUIData('segments_ui', 'usmtf_segs', function (jsonres) {
        segctl.usseg = jsonres.Segments;
    });
    dbService.getUIData('segments_ui', 'nato_segs', function (jsonres) {
        segctl.natoseg = jsonres.Segments;
    });
});

mtfApp.controller('setCtl', function (dbService) {
    var setctl = this;
    setctl.view = "views/setView.html";
    setctl.usset = [];
    setctl.natoset = [];
    dbService.getUIData('sets_ui', 'nato_sets', function (jsonres) {
        setctl.usset = jsonres.Sets;
    });
    dbService.getUIData('sets_ui', 'usmtf_sets', function (jsonres) {
        setctl.natoset = jsonres.Sets;
    });
});

mtfApp.controller('fieldCtl', function (dbService) {
    var fldctl = this;
    fldctl.view = "views/fieldView.html";
    fldctl.usfld = [];
    fldctl.natofld = [];
    dbService.getUIData('fields_ui', 'nato_flds', function (jsonres) {
        fldctl.usfld = jsonres.Fields;
    });
    dbService.getUIData('fields_ui', 'usmtf_flds', function (jsonres) {
        fldctl.natofld = jsonres.Fields;
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