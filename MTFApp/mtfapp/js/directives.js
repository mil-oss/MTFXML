

mtfApp.directive('field', function () {
    var flddir = {
    };
    flddir.restrict = 'E';
    flddir.replace = 'true';
    flddir.scope = {
        field: "=field"
    }
    flddir.transclude=true;
    flddir.templateUrl = 'views/field.html';
    flddir.controller = 'viewCtl';
    flddir.controllerAs= 'vwctl';
    flddir.bindToController= true;
    return flddir;
});

mtfApp.directive('sequence', function () {
    var flddir = {
    };
    flddir.restrict = 'E';
    flddir.replace = 'true';
    flddir.scope = {
        field: "=seq"
    }
    flddir.transclude=true;
    flddir.templateUrl = 'views/sequence.html';
    flddir.controller = 'viewCtl';
    flddir.controllerAs= 'vwctl';
    flddir.bindToController= true;
    return flddir;
});

mtfApp.directive('choice', function () {
    var flddir = {
    };
    flddir.restrict = 'E';
    flddir.replace = 'true';
    flddir.scope = {
        field: "=chce"
    }
    flddir.transclude=true;
    flddir.templateUrl = 'views/choice.html';
    flddir.controller = 'viewCtl';
    flddir.controllerAs= 'vwctl';
    flddir.bindToController= true;
    return flddir;
});