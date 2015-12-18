

mtfApp.directive('mtfField', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            field: "=field",
            list: "=list"
        },
        transclude: true,
        templateUrl: 'templates/field.html',
        controller: 'fldCtl',
        controllerAs: 'fldctl'
    };
});

mtfApp.directive('mtfSet', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            set: "=set",
            list: "=list"
        },
        transclude: true,
        templateUrl: 'templates/set.html',
        controller: 'fldCtl',
        controllerAs: 'fldctl'
    };
});

mtfApp.directive('choice', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            choice: "=chce"
        },
        transclude: true,
        templateUrl: 'views/choice.html',
        controller: 'mtfCtl',
        controllerAs: 'mtfctl',
        bindToController: true

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
