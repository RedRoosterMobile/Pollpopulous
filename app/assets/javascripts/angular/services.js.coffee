services = angular.module('Pollpopulous.services', [])

services.service 'mmModernizr', [ ->
  return Modernizr || {};
]