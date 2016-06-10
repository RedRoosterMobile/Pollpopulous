// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap.min.js
//= require turbolinks

//= require websocket_rails/main
//= require angular
//= require angular-rails-templates
// Angular Templates in app/assets/templates
//= require_tree ../templates

// charts
//= require d3.js
//= require nv.d3.js
//= require angular/modules/angular.audio
//= require angular/modules/angularjs-nvd3-directives
// my angular stuff
//= require angular/controllers
//= require angular/directives
//= require angular/services

// other angular stuff
//= require angular/animate.js
//= require ui-bootstrap-tpls-0.11.2.js
//= require modernizr-2.7.2

//= require_tree .


function calculateAspectRatio($element) {
    return $element.width() / $element.height();
}

$(document).ready(function () {
    var $body = $('body');
    var ratioHandler = function () {
        var ratio = calculateAspectRatio($body);
        if (ratio > 2.125) {
            console.log('bad ratio!');
            $body.removeClass('rolling');
        } else {
            $body.addClass('rolling');
            console.log('good ratio!');
        }
    };
    $(window).resize(ratioHandler);
    ratioHandler();
});
