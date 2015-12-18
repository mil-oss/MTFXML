

mtfApp.directive('mtfField', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            field: "=field",
            flist: "=flist",
        },
        templateUrl: "templates/field.html",
        controller: "fldCtl",
        controllerAs: "fldctl"
    };
});

mtfApp.directive('mtfSet', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            node: "=node",
            slist: "=slist",
            flist: "=flist"
        },
        templateUrl: 'templates/set.html',
        controller: 'setCtl',
        controllerAs: 'setctl'
    };
});
mtfApp.directive('mtfSubset', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            node: "=node",
            slist: "=slist",
            flist: "=flist"
        },
        templateUrl: 'templates/subset.html',
        controller: 'setCtl',
        controllerAs: 'setctl'
    }
});
mtfApp.directive('mtfChoice', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            choice: "=choice",
            slist: "=slist",
            flist: "=flist"
        },
        transclude: true,
        templateUrl: 'templates/choice.html',
        controller: 'setCtl',
        controllerAs: 'setctl'
    };
});
mtfApp.directive('mtfSequence', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            sequence: "=sequence",
            slist: "=slist",
            flist: "=flist"
        },
        transclude: true,
        templateUrl: 'templates/sequence.html',
        controller: 'setCtl',
        controllerAs: 'setctl'
    };
});
mtfApp.directive('mtfTab', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            tabinfo: "=tabinfo"
        },
        transclude: true,
        templateUrl: 'views/mtftab.html',
        controller: 'tabCtrl',
        controllerAs: 'tabctl'
    };
});
