directives = angular.module('Pollpopulous.directives', [])
directives.directive 'mmAlertBox', [ ->
  {
  restrict: 'E'
  templateUrl: 'directives/alert_box.html'
  }
]
# http://localhost:3000/vote_here/what_s_the_bset_soy_sauce_url
directives.directive 'mmGiphy', [
  '$interval','$sce'
  ($interval,$sce) ->

    link = (scope, element, attrs) ->
      if !scope.keywords
        scope.keywords = [
          'funny'
          'cat'
        ]
      keywordsQuery = scope.keywords.join('+')
      scope.giphyUrl = "https://api.giphy.com/v1/gifs/search?q=#{keywordsQuery}&api_key=#{scope.apiKey}&limit=10"
      counter = 0
      playing = false
      $.get scope.giphyUrl, (data) ->
        scope.results = data.data
        startShow()

      startShow = ->
        if scope.results and scope.results.length > 0
          playing = true
          scope.timeOut = $interval((->
            image = scope.results[counter].images.fixed_height
            if image? and image.mp4?
              scope.image_mp4 = $sce.trustAsResourceUrl(image.mp4)
              scope.image_webp = $sce.trustAsResourceUrl(image.webp)

              vid = element.find('video');
              if vid? and vid.length > 0
                # reload video to new source
                vid[0].load()

            counter++
            counter = 0 if counter >= scope.results.length-1
            return
          ), if scope.speedMs then scope.speedMs else 3000)
        return

      stopShow = ->
        $interval.cancel scope.timeOut
        playing = false
        return

      element.click ->
        if playing then stopShow() else startShow()
      return

    {
    restrict: 'E'
    scope:
      keywords: '='
      title: '@'
      speedMs: '@'
      apiKey: '@'
    link: link
    template: """
      <div ng-if="image_mp4" class="giphy-container polaroid-images">
        <a title="{{title}}">
          <video  width="100%" height="120" class="img-responsive" autoplay loop>
            <source ng-src="{{image_mp4}}" type="video/mp4">
            <source ng-src="{{image_webp}}" type="video/webp">
            Your browser does not support the video tag.
          </video>
        </a>
      </div>
      """
    }
]