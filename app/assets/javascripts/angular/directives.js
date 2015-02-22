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
        scope.setGif = function(url) {
            var img = new Image();
            img.onload = function() {

                var link=$('<a title="'+(scope.title?scope.title:"There'll be cats!")+'">');
                element.children().first().html('').append(link.append(img)[0]);
                startCount++;

                scope.timeOut = $timeout(function () {
                    if (startCount>=gifResults.length) {
                        startCount=0;
                    }
                    console.log('next cat');
                    scope.setGif(gifResults[startCount].images.downsized)
                },(scope.speedMs?scope.speedMs:3000));

            };
            img.className+=" img-responsive";
            img.src = url.url;
        };


        scope.startShow=function() {
            if (!!scope.keywords)
                scope.keywords = ['funny','cat'];

            var keywordsQuery = scope.keywords.join('+');
            scope.giphyUrl = "https://api.giphy.com/v1/gifs/search?q="+keywordsQuery+"&api_key=dc6zaTOxFJmzC";
            $.get( scope.giphyUrl, function( data ) {
                var results = data.data;
                playing=true;
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
            if (playing)
                scope.stopShow();
            else
                scope.startShow();
        });
        $timeout(scope.startShow);
    };

    return {
        restrict: 'E',
        scope: {
            keywords: '=',
            title: '@',
            speedMs: '@'
        },
        link: link,
        template: '<div class="giphy-container polaroid-images"></div>'
    };
}]);