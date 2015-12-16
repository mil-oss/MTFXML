

mtfApp.directive('field', function () {
    var flddir = {
    };
    flddir.restrict = 'E';
    flddir.replace = 'true';
    flddir.scope = {
        field: "=field"
    };
    flddir.transclude = true;
    flddir.templateUrl = 'views/field.html';
    flddir.controller = 'mtfCtl';
    flddir.controllerAs = 'mtfctl';
    flddir.bindToController = true;
    return flddir;
});

mtfApp.directive('sequence', function () {
    var seqdir = {
    };
    seqdir.restrict = 'E';
    seqdir.replace = 'true';
    seqdir.scope = {
        seq: "=seq"
    };
    seqdir.transclude = true;
    seqdir.templateUrl = 'views/sequence.html';
    seqdir.controller = 'mtfCtl';
    seqdir.controllerAs = 'mtfctl';
    seqdir.bindToController = true;
    return seqdir;
});

mtfApp.directive('choice', function () {
    var chcdir = {
    };
    chcdir.restrict = 'E';
    chcdir.replace = 'true';
    chcdir.scope = {
        choice: "=chce"
    };
    chcdir.transclude = true;
    chcdir.templateUrl = 'views/choice.html';
    chcdir.controller = 'mtfCtl';
    chcdir.controllerAs = 'mtfctl';
    chcdir.bindToController = true;
    return chcdir;
});

mtfApp.directive('mtfTab', function () {
    var mtftab = {
    };
    mtftab.restrict = 'E';
    mtftab.replace = 'true';
    mtftab.scope = {
        tabinfo:'=tabinfo'
    };
    mtftab.transclude = true;
    mtftab.templateUrl = 'views/mtftab.html';
    mtftab.controller = 'tabCtrl';
    mtftab.controllerAs = 'tabctl';
    return mtftab;
});
