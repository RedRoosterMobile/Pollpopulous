var controllers = angular.module('Pollpopulous.controllers',['nvd3ChartDirectives','ngAudio','ngAnimate']);

controllers.controller('mainController',['$scope','$http','$timeout','ngAudio',function($scope,$http,$timeout,$ngAudio) {

    $scope.sfxBlip = $ngAudio.load("/blip.wav");
    $scope.sfxCoin = $ngAudio.load("/coin.wav");
    $scope.sfxOverAndOut = $ngAudio.load("/overandout_long.wav");
    $scope.xFunction = function(){
        return function(d) {
            return d.name;
        };
    };
    $scope.yFunction = function(){
        return function(d) {
            return d.votes.length;
        };
    };
    $scope.descriptionFunction = function(){
        return function(d){
            return d.name;
        }
    };
    $scope.getIndexOfCandidate = function(candidate) {
        return $scope.data.candidates.indexOf(candidate);
    };
    $scope.defs= function(svg) {
        console.log(svg);
    };
    $scope.alerts = [
       /* { type: 'danger', msg: 'Oh snap! Change a few things up and try submitting again.' },
         { type: 'success', msg: 'Well done! You successfully read this important alert message.' }*/
    ];
    $scope.closeAlert = function(index) {
        $scope.alerts.splice(index, 1);
        $scope.sfxOverAndOut.play();
    };

    var colors = [
        // fixme: gradients need to be known in nvd3-directive
        'url(#gradientForegroundPurple)',
        'url(#gradientForegroundRed)',
        // TODO: proper colors or gradients
        'rgba(120,230,122,0.3)',
        'gold',
        'purple',
        'darkBlue',
        'lightBrown',
        'lightRed',
        'darkOrange'

    ];
    $scope.color = function() {
      return function(d) {
          return colors[$scope.getIndexOfCandidate(d.data)];
      }
    };


    $scope.data = {};
    var url = location.pathname.split('/').splice(-1);
    var dispatcher = new WebSocketRails(location.host + '/websocket');
    var channel = dispatcher.subscribe(url[0]);

    $scope.init = function(msg,poll_id){
        $scope.data.keywords = ['funny','cat'];
        $scope.data.nickname='';
        console.log('init called');
        //console.log(msg);

        $scope.data.knownSender = false;
        $scope.data.optionName = '';
        console.log(msg);
        $scope.data.candidates=msg;
        $scope.data.poll_id=poll_id;

        var storedNickname = localStorage.getItem('nickname');
        if (storedNickname && storedNickname.length > 0) {
            $scope.data.nickname = storedNickname;
            $scope.data.knownSender=true;
        }
        // catch broadcasts on channel
        channel.bind('new_candidate', function(data) {
            $scope.$apply(function() {
                $scope.data.candidates.push(data);
            });
        });
        channel.bind('revoked_vote', function(data) {
            console.log('revoked vote-----------------');
            var smash = false;
            for (var i=0;i<$scope.data.candidates.length;i++) {
                if ($scope.data.candidates[i].id==data.candidate_id) {
                    for (var j=0;j<$scope.data.candidates[i].votes.length;j++) {
                        var isSameName=$scope.data.candidates[i].votes[j].nickname==data.vote.nickname;
                        var isSameId=$scope.data.candidates[i].votes[j].id==data.vote.id;
                        if (isSameName && isSameId) {
                            $scope.$apply(function() {
                                // kick it out
                                $scope.data.candidates[i].votes.splice(j, 1);
                                smash = true;
                            });
                        }
                        if (smash) break
                    }
                }
                if (smash) break
            }
        });
        channel.bind('new_vote', function(data) {
            console.log('new_vote');
            for (var i=0;i<$scope.data.candidates.length;i++) {
                if ($scope.data.candidates[i].id==data.candidate_id) {
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
            $scope.data.knownSender = true;
            localStorage.setItem('nickname',$scope.data.nickname);
            $scope.sfxCoin.play();
        };
        var wsFailure = function(data) {
            console.log('ws: failed');
            console.log(data);
            $scope.$apply(function(){
                $scope.alerts.push({
                        msg: data.message,
                        type: 'warning'
                });
            });
            $scope.sfxBlip.play();
            // trigger leave animation after certain time
            $timeout(function() {
                var numAlerts = $scope.alerts.length;
                if (numAlerts) {
                    $scope.closeAlert($scope.alerts[numAlerts - 1]);
                }
            },3000); // fiqure out a way to eliminate this timer
        };


        $scope.vote = function(option_id) {
          console.log('clicked vote');
            var message = {
                nickname: $scope.data.nickname,
                candidate_id: option_id ,
                url: url[0],
                poll_id: $scope.data.poll_id
            };
            dispatcher.trigger('poll.vote_on', message, wsSuccess, wsFailure);
        };
        $scope.revokeVote = function(option) {
            console.log('clicked revoke');
            var notYours=true;
            for (var i=0;i<option.votes.length;i++) {
                if (option.votes[i].nickname==$scope.data.nickname  ) {
                    var message = {
                        nickname: $scope.data.nickname,
                        vote_id: option.votes[i].id,
                        poll_id: $scope.data.poll_id,
                        candidate_id: option.id,
                        url: url[0]
                    };
                    dispatcher.trigger('poll.revoke_vote', message, wsSuccess, wsFailure);
                    // end loop
                    notYours=false;
                    i=option.votes.length+1;
                }
            }
            if (notYours && option.votes.length > 0) {
                $timeout(function () {
                    wsFailure({message: 'Not your vote'});
                });
            } else if(option.votes.length == 0) {
                $timeout(function () {
                    wsFailure({message: 'Ever heard of negative votes?'});
                });
            }
        };
        $scope.addOption = function() {
            var title = $scope.data.optionName;
            var nickname =$scope.data.nickname;
            if (nickname != '' && title != '') {
                var message = { url: url,poll_id: $scope.data.poll_id, name: title };
                dispatcher.trigger('poll.add_option', message, wsSuccess, wsFailure);
            } else if (title=='') {
                console.log("define option title first ");
                $timeout(function () {
                    wsFailure({message: 'define option title first'});
                });
            } else if (nickname=='') {
                console.log("define your nickname first");
                $timeout(function () {
                    wsFailure({message: 'define your nickname first'});
                });
            }
        };
    };
}]);