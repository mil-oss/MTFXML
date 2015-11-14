mtfApp.controller('mtfCtl', function ($scope, DlgBx, dbService, xsltService) {
    var mtfctl = this;
    mtfctl.msgview = "views/msgView.html";
    mtfctl.segmentview = "views/segmentView.html";
    mtfctl.setview = "views/setView.html";
    mtfctl.fieldview = "views/fieldView.html";
    mtfctl.msgview = "";
    mtfctl.choiceview = "";
    mtfctl.segmentview = "";
    mtfctl.setview = "";
    mtfctl.fieldview = "";
    mtfctl.selectedMsg = [];
    mtfctl.selectedSegment = [];
    mtfctl.selectedSet = [];
    mtfctl.selectedField = [];
    mtfctl.selectedSegment = [];
    mtfctl.selectedSet = [];
    mtfctl.selectedField = [];
    mtfctl.selectedStd = "US";
    mtfctl.view = "";
    //
    
    dbService.syncResources(resources,function(){
        console.log("data loaded");
        dbService.updateUIData(xsltService);
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
    mtfctl.selectMsg = function (std, msg, k) {
        mtfctl.view = "views/msgView.html";
        mtfctl.selected = k;
        mtfctl.selectedStd = std;
        mtfctl.selectedMsg = msg;
        console.log(mtfctl.selectedMsg);
    };
    mtfctl.selectSegment = function (std, seg, k) {
        console.log("selectSegment");
        mtfctl.view = "views/segmentView.html";
        mtfctl.selected = k;
        mtfctl.selectedStd = std;
        mtfctl.selectedSegment = seg;
    };
    mtfctl.selectSet = function (std, set, k) {
        mtfctl.view = "views/setView.html";
        mtfctl.selected = k;
        mtfctl.selectedStd = std;
        mtfctl.selectedSet = set;
    };
    mtfctl.selectField = function (std, field, k) {
        mtfctl.view = "views/fieldView.html";
        mtfctl.selected = k;
        mtfctl.selectedStd = std;
        mtfctl.selectedField = field;
    };
    mtfctl.isSelected = function (k) {
        return mtfctl.selected === k;
    };
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