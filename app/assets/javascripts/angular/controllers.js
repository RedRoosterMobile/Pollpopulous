var controllers = angular.module('Pollpopulous.controllers',[]);

controllers.controller('mainController',['$scope','$http','$timeout',function($scope,$http,$timeout) {

    $scope.data = {};
    var url = location.pathname.split('/').splice(-1);
    var dispatcher = new WebSocketRails(location.host + '/websocket');


    //$scope.$on('notification-event', function(event, args) {});
    // TODO: move init to service/factory
    $scope.init = function(msg){
        console.log('init called');
        console.log(msg);

        // todo: build html via: ng-repeat?
        $scope.data.candidates=msg;
        var storedNickname = localStorage.getItem('nickname');
        //if (storedNickname && storedNickname.length > 0)
        //    nicknameForm.find('input').attr('disabled','disabled');
        $scope.data.nickname = storedNickname;


        $scope.vote = function() {
          console.log('clicked vote');
        };
        $scope.revokeVote = function() {
            console.log('clicked revoke');
        };
        $scope.removeOption = function() {
            console.log('clicked remove');
        };
    };
}]);