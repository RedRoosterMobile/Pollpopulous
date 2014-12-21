
var name = '';
var channel='';
$(function(){

    var nicknameForm = $('form#nickname_form');
    var addCandidateForm = $('form#add_candidate_form');
    var dispatcher = new WebSocketRails(location.host + '/websocket');
    var url = location.pathname.split('/').splice(-1);
    console.log(url);
    channel = dispatcher.subscribe(url[0]);
    channel.bind('new_candidate', function(data) {
        console.log('new option successfully created via broadcast');
        console.log(data);
        $('table').find('tbody').append('<tr><td>' + data.name + '</td><td>VOTES</td><td>VOTE</td></tr>');
    });

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