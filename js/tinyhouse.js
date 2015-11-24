// Initialize angular
var tinyHouseApp = angular.module('tinyHouseApp', ['ngRoute', 'angular.filter']);

tinyHouseApp.config(function($routeProvider, $locationProvider) {
  $routeProvider
    .when('/about', {
      templateUrl : 'partials/about.html',
      controller  : 'aboutController'
    })
    .when('/contact', {
      templateUrl : 'partials/contact.html',
      controller  : 'contactController'
    })
    .when('/faq', {
      templateUrl : 'partials/faq.html',
      controller  : 'newsController'
    })
    .when('/news', {
      templateUrl : 'partials/news.html',
      controller  : 'newsController'
    })
    .when('/resources/community', {
      templateUrl : 'partials/community.html',
      controller  : 'communityController'
    })
    .otherwise({
      redirectTo: '/about'
    });

  // use the HTML5 History API
  $locationProvider.html5Mode(true);
});
