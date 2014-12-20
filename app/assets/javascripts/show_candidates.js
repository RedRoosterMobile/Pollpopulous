
var name = 'john';
$(function(){
    var dispatcher = new WebSocketRails(location.host + '/websocket');
    var url = location.pathname.split('/').splice(-1);


    var channel = dispatcher.subscribe(url);

    var success = function(response) {
        console.log("Added Option: "+response.message);
        console.log(response);
    };

    var failure = function(response) {
        console.log("Option not added: "+response.message);
        console.log(response);
    };

    var message = { url: url, name: name };
    dispatcher.trigger('poll.add_option', message, success, failure);






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