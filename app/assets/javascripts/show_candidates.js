
var name = '';
var channel='';
console.log('loading modules Pollpopulous');
var coverEditor = angular.module('Pollpopulous',['templates','ui.router','ui.bootstrap','Pollpopulous.controllers','Pollpopulous.directives','Pollpopulous.services','ngAnimate']);

// manually bootstraped because of rails :turbolinks
// @see: http://stackoverflow.com/questions/14797935/using-angularjs-with-turbolinks
$(document).on('ready page:load', function(event) {
    console.log('put on me strappings!');
    angular.bootstrap($('div.Pollpopulous')[0], ['Pollpopulous']);
    console.log('..click, clack!');
});
