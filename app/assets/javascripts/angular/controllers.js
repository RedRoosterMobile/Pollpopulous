var controllers = angular.module('Pollpopulous.controllers',[]);

controllers.controller('mainController',['$scope','$http','$timeout',function($scope,$http,$timeout) {

    $scope.data = {};
    var url = location.pathname.split('/').splice(-1);
    var dispatcher = new WebSocketRails(location.host + '/websocket');
    var channel = dispatcher.subscribe(url[0]);

    $scope.init = function(msg,poll_id){
        console.log('init called');
        console.log(msg);
        $scope.data.optionName='';

        // todo: build html via: ng-repeat?
        $scope.data.candidates=msg;
        $scope.data.poll_id=poll_id;

        var storedNickname = localStorage.getItem('nickname');
        //if (storedNickname && storedNickname.length > 0)
        //    nicknameForm.find('input').attr('disabled','disabled');
        $scope.data.nickname = storedNickname;


        // catch broadcasts on channel
        channel.bind('new_candidate', function(data) {
            $scope.$apply(function() {
                $scope.data.candidates.push(data);
            });
        });
        channel.bind('new_vote', function(data) {
            console.log('new_vote');
            for (var i=0;i<$scope.data.candidates.length;i++) {
                console.log(' '+data.poll_id+' '+$scope.data.candidates[i].poll_id);
                if ($scope.data.candidates[i].poll_id==data.poll_id) {
                    $scope.$apply(function() {
                        // update goes here
                        $scope.data.candidates[i].votes.push(data.vote);
                    });
                }
            }
        });

        var wsSuccess= function(data){
            console.log('ws: successful');
            console.log(data);
        };
        var wsFailure = function(data) {
            console.log('ws: failed');
            console.log(data);
        };


        $scope.vote = function(option_id) {
          console.log('clicked vote');
            console.log(option_id);
            console.log($scope.data.nickname);
            console.log($scope.data.poll_id);
            var message = {
                nickname: $scope.data.nickname,
                candidate_id: option_id ,
                url: url[0],
                poll_id: $scope.data.poll_id
            };
            dispatcher.trigger('poll.vote_on', message, wsSuccess, wsFailure);
        };
        $scope.revokeVote = function(option_id) {
            console.log('clicked revoke');
            console.log(option_id);
            console.log($scope.data.nickname);
            console.log($scope.data.poll_id);
        };
        $scope.removeOption = function(option_id) {
            console.log('clicked remove option');
            console.log(option_id);
            console.log($scope.data.nickname);
            console.log($scope.data.poll_id);
        };
        $scope.addOption = function() {
            console.log($scope.data.optionName);
            var title = $scope.data.optionName;
            var nickname =$scope.data.nickname;
            if (nickname != '' && title != '') {
                var message = { url: url,poll_id: $scope.data.poll_id, name: title };
                dispatcher.trigger('poll.add_option', message, wsSuccess, wsFailure);
                //nicknameForm.find('input').attr('disabled','disabled');
                // todo: save nickname somewhere
                localStorage.setItem('nickname',nickname);
            } else if (title=='') {
                console.log("define option title first ");
            } else if (nickname=='') {
                console.log("define your nickname first");
            }
        };
    };
}]);