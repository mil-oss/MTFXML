

mtfApp.directive('mtfField', function () {
    return{
        restrict: 'E',
        replace: 'true',
        scope: {
            field: "=field"
        },
        transclude: true,
        templateUrl: 'views/field.html',
        controller: 'mtfCtl',
        controllerAs: 'mtfctl'
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
