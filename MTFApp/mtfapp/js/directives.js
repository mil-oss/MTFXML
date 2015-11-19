

mtfApp.directive('field', function () {
    var flddir = {
    };
    //flddir.replace = 'true';
    flddir.scope = {
        field: "=data"
    }
    flddir.transclude=true;
    flddir.templateUrl = 'templates/fieldView.html';
    flddir.controller = 'fldCtl';
    flddir.controllerAs= 'fldctl';
    flddir.bindToController= true;
    return flddir;
});