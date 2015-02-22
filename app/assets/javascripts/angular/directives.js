var directives = angular.module('Pollpopulous.directives',[]);

directives.directive('mmAlertBox',[ function () {
    return {
        restrict: 'E',
        templateUrl: 'directives/alert_box.html'
    };
}]);


directives.directive('mmGiphy',['$timeout', function ($timeout) {

    var gifResults;

    var playing;


    var startCount=0;
    var link = function ( scope, element, attrs ) {
        console.log('@@@@@@@@@@@@@@@@@@@@@@@@@@');


        scope.setGif = function(url) {
            var img = new Image();
            img.onload = function() {
                var link=$('<a title="There\'ll be cats!">');
                element.children().first().html('').append(link.append(img)[0]);
                startCount++;

                scope.timeOut = $timeout(function () {
                    if (startCount>=gifResults.length) {
                        startCount=0;
                    }
                    console.log('next cat');
                    scope.setGif(gifResults[startCount].images.downsized)
                },3000);

            };
            img.className+=" img-responsive";
            img.src = url.url;
        };


        scope.startShow=function() {
            playing=true;
            var keywordsQuery = scope.keywords.join('+');
            scope.giphyUrl = "http://api.giphy.com/v1/gifs/search?q="+keywordsQuery+"&api_key=dc6zaTOxFJmzC";
            $.get( scope.giphyUrl, function( data ) {
                var results = data.data;
                console.log(results);

                gifResults=results;
                if (results && results.length>0)
                    scope.setGif(results[0].images.downsized);
            });
        };
        scope.stopShow = function() {
            $timeout.cancel(scope.timeOut);
            playing=false;
        };

        element.click(function() {
            console.log(scope.timeOut);
            if (playing)
                scope.stopShow();
            else {
                scope.startShow();
            }
        });
        $timeout(scope.startShow);
    };

    return {
        restrict: 'E',
        scope: {
          keywords: '='
        },
        link: link,
        template: '<div class="giphy-container polaroid-images"></div>'
    };
}]);