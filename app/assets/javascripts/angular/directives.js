var directives = angular.module('Pollpopulous.directives',[]);

directives.directive('mmAlertBox',[ function () {
    return {
        restrict: 'E',
        templateUrl: 'directives/alert_box.html'
    };
}]);