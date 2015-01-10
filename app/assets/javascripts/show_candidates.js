
var name = '';
var channel='';

$(function(){
    var url = location.pathname.split('/').splice(-1);

    var successVote = function(response) {
        console.log("Added Vote: "+response);
        console.log(response);
    };

    var failureVote = function(response) {
        console.log("Vote failed: "+response);
        console.log(response);
    };

    $('a.vote').on('click',function(event){
        console.log('clicked vote');
        // todo: what to sent to backend
        // we need at least:
        // name of voter
        // and the candidate_id
        var option_id = $(this).attr('data-option');
        var nickname = $('form#nickname_form').find('input').val();
        var message = {
            nickname: nickname,
            candidate_id: option_id ,
            url: url[0]
        };

        dispatcher.trigger('poll.vote_on', message, successVote, failureVote);
    });

    var nicknameForm = $('form#nickname_form');
    var addCandidateForm = $('form#add_candidate_form');
    var dispatcher = new WebSocketRails(location.host + '/websocket');
    var storedNickname = localStorage.getItem('nickname');
    if (storedNickname && storedNickname.length > 0)
        nicknameForm.find('input').attr('disabled','disabled');
    nicknameForm.find('input').val(storedNickname);

    console.log(url);
    channel = dispatcher.subscribe(url[0]);
    channel.bind('new_candidate', function(data) {
        console.log('new option successfully created via broadcast');
        console.log(data);
        $('table').find('tbody').append('<tr><td>' + data.name + '</td><td>VOTES</td><td>VOTE</td></tr>');
    });

    var deleteName = function() {
        nicknameForm.find('input').removeAttr('disabled');
        nicknameForm.find('input').val('');
        localStorage.removeItem('nickname');
    };

    var success = function(response) {
        console.log("Added Option: "+response);
        console.log(response);
    };

    var failure = function(response) {
        console.log("Option not added: "+response);
        console.log(response);
    };


    function addOption() {
        var title = addCandidateForm.find('input').val();
        var nickname = nicknameForm.find('input').val();
        if (nickname != '' && title != '') {

            var message = { url: url, name: title };
            dispatcher.trigger('poll.add_option', message, success, failure);
            nicknameForm.find('input').attr('disabled','disabled');
            // todo: save nickname somewhere
            localStorage.setItem('nickname',nickname);
        } else if (title=='') {
            console.log("define option title first ");
        } else if (nickname=='') {
            console.log("define your nickname first");
        }
    }
    addCandidateForm.submit(function( event ) {
        event.preventDefault();
        addOption();
    });







    dispatcher.on_open = function (data) {
        console.log('Connection has been established:');
        console.log(data);
        console.log(data.connection_id);
    };
    dispatcher.on_close = function () {
        console.log('connection closed. attemtping reconnect');
        dispatcher = new WebSocketRails(location.host + '/websocket');
        channel = dispatcher.subscribe(url);
    };
    dispatcher.on_error = function () {
        console.log('error')
    };

});