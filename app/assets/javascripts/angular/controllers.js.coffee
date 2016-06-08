controllers = angular.module('Pollpopulous.controllers', [
  'nvd3ChartDirectives'
  'ngAudio'
  'ngAnimate'
])
controllers.controller 'mainController', [
  '$scope'
  '$http'
  '$timeout'
  'ngAudio'
  ($scope, $http, $timeout, $ngAudio) ->
    # fnord: on ios, only last loaded sound will play
    $scope.sfxOverAndOut = $ngAudio.load('/overandout_long.wav')
    $scope.sfxBlip = $ngAudio.load('/blip.wav')
    $scope.sfxCoin = $ngAudio.load('/coin.wav')

    $scope.xFunction = ->
      (d) ->
        d.name

    $scope.yFunction = ->
      (d) ->
        d.votes.length

    $scope.descriptionFunction = ->
      (d) ->
        d.name

    $scope.getIndexOfCandidate = (candidate) ->
      $scope.data.candidates.indexOf candidate

    $scope.defs = (svg) ->
      console.log svg
      return

    $scope.alerts = []

    $scope.closeAlert = (index) ->
      $scope.alerts.splice index, 1
      $scope.sfxOverAndOut.play()
      return

    colors = [
      'url(#gradientForegroundPurple)'
      'url(#gradientForegroundRed)'
      'rgba(120,230,122,0.3)'
      'gold'
      'purple'
      'darkBlue'
      'lightBrown'
      'lightRed'
      'darkOrange'
    ]

    $scope.color = ->
      (d) ->
        colors[$scope.getIndexOfCandidate(d.data)]

    $scope.data = {}
    url = location.pathname.split('/').splice(-1)
    dispatcher = new WebSocketRails(location.host + '/websocket')
    channel = dispatcher.subscribe(url[0])

    $scope.init = (msg, poll_id) ->
      $scope.data.keywords = [
        'arnold'
        'schwarzenegger'
      ]
      $scope.data.nickname = ''
      console.log 'init called'
      #console.log(msg);
      $scope.data.knownSender = false
      $scope.data.optionName = ''
      console.log msg
      $scope.data.candidates = msg
      $scope.data.poll_id = poll_id
      storedNickname = localStorage.getItem('nickname')
      if storedNickname and storedNickname.length > 0
        $scope.data.nickname = storedNickname
        $scope.data.knownSender = true
      # catch broadcasts on channel
      channel.bind 'new_candidate', (data) ->
        $scope.$apply ->
          $scope.data.candidates.push data
          return
        return
      channel.bind 'revoked_vote', (data) ->
        console.log 'revoked vote-----------------'
        smash = false
        i = 0
        # madness!!
        while i < $scope.data.candidates.length
          if $scope.data.candidates[i].id == data.candidate_id
            j = 0
            while j < $scope.data.candidates[i].votes.length
              isSameName = $scope.data.candidates[i].votes[j].nickname == data.vote.nickname
              isSameId = $scope.data.candidates[i].votes[j].id == data.vote.id
              if isSameName and isSameId
                $scope.$apply ->
                  # kick it out
                  $scope.data.candidates[i].votes.splice j, 1
                  smash = true
                  return
              if smash
                break
              j++
          if smash
            break
          i++
        return
      channel.bind 'new_vote', (data) ->
        console.log 'new_vote'
        i = 0
        while i < $scope.data.candidates.length
          if $scope.data.candidates[i].id == data.candidate_id
            $scope.$apply ->
              # update goes here
              $scope.data.candidates[i].votes.push data.vote
              return
          i++
        return

      wsSuccess = (data) ->
        console.log 'ws: successful'
        console.log data
        $scope.data.knownSender = true
        localStorage.setItem 'nickname', $scope.data.nickname
        $scope.sfxCoin.play()
        return

      wsFailure = (data) ->
        console.log 'ws: failed'
        console.log data
        $scope.$apply ->
          $scope.alerts.push
            msg: data.message
            type: 'warning'
            timestamp: Date.now()
          return
        $scope.sfxBlip.play()
        # trigger leave animation after certain time
        $timeout (->
          numAlerts = $scope.alerts.length
          if numAlerts
            $scope.closeAlert $scope.alerts[numAlerts - 1]
          return
        ), 3000
        # fiqure out a way to eliminate this timer
        return

      $scope.vote = (option_id) ->
        console.log 'clicked vote'
        if $scope.data.nickname and $scope.data.nickname != ''
          message =
            nickname: $scope.data.nickname
            candidate_id: option_id
            url: url[0]
            poll_id: $scope.data.poll_id
          dispatcher.trigger 'poll.vote_on', message, wsSuccess, wsFailure
        else
          $timeout ->
            wsFailure message: 'define your nickname first'
            return
        return

      $scope.revokeVote = (option) ->
        console.log 'clicked revoke'
        notYours = true
        i = 0
        while i < option.votes.length
          if option.votes[i].nickname == $scope.data.nickname
            message =
              nickname: $scope.data.nickname
              vote_id: option.votes[i].id
              poll_id: $scope.data.poll_id
              candidate_id: option.id
              url: url[0]
            dispatcher.trigger 'poll.revoke_vote', message, wsSuccess, wsFailure
            # end loop
            notYours = false
            i = option.votes.length + 1
          i++
        if notYours and option.votes.length > 0
          $timeout ->
            wsFailure message: 'Not your vote'
            return
        else if option.votes.length == 0
          $timeout ->
            wsFailure message: 'Ever heard of negative votes?'
            return
        return

      $scope.addOption = ->
        # todo: min nickname length
        title = $scope.data.optionName.trim()
        nickname = $scope.data.nickname.trim()
        if title? and nickname? and nickname != '' and title != ''
          message =
            url: url
            poll_id: $scope.data.poll_id
            name: title
          dispatcher.trigger 'poll.add_option', message, wsSuccess, wsFailure
        else if title? or title == ''
          console.log 'define option title first '
          $timeout ->
            wsFailure message: 'define option title first'
            return
        else if nickname? or nickname == ''
          console.log 'define your nickname first'
          $timeout ->
            wsFailure message: 'define your nickname first'
            return
        return

      return

    return
]

# ---
# generated by js2coffee 2.2.0