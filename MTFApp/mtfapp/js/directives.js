

mtfApp.directive('field', function () {
    var flddir = {
    };
    flddir.restrict = 'E';
    flddir.replace = 'true';
    flddir.templateUrl = 'templates/fieldView.html';
    flddir.scope = {
        field: "="
    }
    flddir.controller = 'fldCtl';
    flddir.controllerAs= 'fldctl';
    flddir.bindToController= true;
    return flddir;
});